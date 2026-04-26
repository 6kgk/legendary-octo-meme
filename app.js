const chatData = [
    {
        id: 1,
        name: '张三',
        avatar: 'https://picsum.photos/seed/zhangsan/200/200',
        lastMessage: '好的，明天见！',
        lastTime: '10:32',
        unread: 2,
        online: true,
        messages: [
            { id: 101, type: 'text', content: '在吗？明天有没有时间一起吃饭？', time: '09:15', isMe: false },
            { id: 102, type: 'text', content: '好啊，几点？', time: '09:20', isMe: true },
            { id: 103, type: 'text', content: '中午12点怎么样？我知道一家新开的川菜馆', time: '09:22', isMe: false },
            { id: 104, type: 'image', content: 'https://picsum.photos/seed/restaurant1/400/300', time: '09:23', isMe: false },
            { id: 105, type: 'text', content: '看起来不错！地址在哪？', time: '09:25', isMe: true },
            { id: 106, type: 'text', content: '就在市中心那个商场三楼', time: '09:28', isMe: false },
            { id: 107, type: 'image', content: 'https://picsum.photos/seed/map123/400/300', time: '09:28', isMe: false },
            { id: 108, type: 'text', content: '好的，明天见！', time: '10:32', isMe: true }
        ]
    },
    {
        id: 2,
        name: '李四',
        avatar: 'https://picsum.photos/seed/lisi/200/200',
        lastMessage: '收到，谢谢！',
        lastTime: '昨天',
        unread: 0,
        online: true,
        messages: [
            { id: 201, type: 'text', content: '上次那个项目方案我改好了，发你看看', time: '14:20', isMe: false },
            { id: 202, type: 'image', content: 'https://picsum.photos/seed/document1/400/500', time: '14:21', isMe: false },
            { id: 203, type: 'text', content: '好的，我看一下', time: '14:25', isMe: true },
            { id: 204, type: 'text', content: '第三页的数据需要更新一下，用最新的统计', time: '14:35', isMe: true },
            { id: 205, type: 'text', content: '好的，我马上修改', time: '14:40', isMe: false },
            { id: 206, type: 'image', content: 'https://picsum.photos/seed/chart1/400/300', time: '15:00', isMe: false },
            { id: 207, type: 'text', content: '改好了，你看看这样行不行', time: '15:01', isMe: false },
            { id: 208, type: 'text', content: '可以，没问题了', time: '15:10', isMe: true },
            { id: 209, type: 'text', content: '收到，谢谢！', time: '15:11', isMe: false }
        ]
    },
    {
        id: 3,
        name: '妈妈',
        avatar: 'https://picsum.photos/seed/mom/200/200',
        lastMessage: '记得吃饭哦',
        lastTime: '昨天',
        unread: 1,
        online: false,
        messages: [
            { id: 301, type: 'text', content: '儿子，周末回不回家吃饭？', time: '10:00', isMe: false },
            { id: 302, type: 'text', content: '这周末可能加班，回不去😅', time: '10:05', isMe: true },
            { id: 303, type: 'text', content: '好吧，那你照顾好自己', time: '10:08', isMe: false },
            { id: 304, type: 'image', content: 'https://picsum.photos/seed/food1/400/300', time: '10:10', isMe: false },
            { id: 305, type: 'text', content: '今天我做了你最爱吃的红烧肉，给你看看', time: '10:11', isMe: false },
            { id: 306, type: 'text', content: '哇！看着就好吃！🤤', time: '10:15', isMe: true },
            { id: 307, type: 'image', content: 'https://picsum.photos/seed/food2/400/300', time: '10:12', isMe: false },
            { id: 308, type: 'text', content: '等下周回来我再做给你吃', time: '10:20', isMe: false },
            { id: 309, type: 'text', content: '好啊！', time: '10:25', isMe: true },
            { id: 310, type: 'text', content: '记得吃饭哦', time: '18:00', isMe: false }
        ]
    },
    {
        id: 4,
        name: '公司群',
        avatar: 'https://picsum.photos/seed/group/200/200',
        lastMessage: '[图片]',
        lastTime: '昨天',
        unread: 5,
        online: true,
        isGroup: true,
        messages: [
            { id: 401, type: 'text', content: '各位，下周团建活动安排出来了', time: '09:00', isMe: false, sender: 'HR-小王' },
            { id: 402, type: 'image', content: 'https://picsum.photos/seed/schedule1/400/600', time: '09:01', isMe: false, sender: 'HR-小王' },
            { id: 403, type: 'text', content: '有两个方案，大家看看选哪个', time: '09:02', isMe: false, sender: 'HR-小王' },
            { id: 404, type: 'text', content: '方案A不错，去海边', time: '09:10', isMe: true },
            { id: 405, type: 'text', content: '我觉得方案B好，爬山更有意思', time: '09:15', isMe: false, sender: '老赵' },
            { id: 406, type: 'image', content: 'https://picsum.photos/seed/mountain1/400/300', time: '09:16', isMe: false, sender: '老赵' },
            { id: 407, type: 'text', content: '那就投票决定吧', time: '09:20', isMe: false, sender: 'HR-小王' },
            { id: 408, type: 'text', content: '收到，马上处理', time: '09:25', isMe: false, sender: '小李' }
        ]
    },
    {
        id: 5,
        name: '王五',
        avatar: 'https://picsum.photos/seed/wangwu/200/200',
        lastMessage: '周末一起去？',
        lastTime: '周三',
        unread: 0,
        online: false,
        messages: [
            { id: 501, type: 'text', content: '周末要不要一起去打篮球？', time: '15:00', isMe: false },
            { id: 502, type: 'text', content: '好久没运动了，可以啊', time: '15:05', isMe: true },
            { id: 503, type: 'text', content: '我最近发现一个露天球场，环境很好', time: '15:08', isMe: false },
            { id: 504, type: 'image', content: 'https://picsum.photos/seed/basketball1/400/300', time: '15:10', isMe: false },
            { id: 505, type: 'text', content: '不错！周六下午？', time: '15:12', isMe: true },
            { id: 506, type: 'text', content: '行，下午3点怎么样', time: '15:15', isMe: false },
            { id: 507, type: 'text', content: '没问题，到时候见', time: '15:20', isMe: true },
            { id: 508, type: 'text', content: '周末一起去？', time: '15:21', isMe: false }
        ]
    },
    {
        id: 6,
        name: '快递小哥',
        avatar: 'https://picsum.photos/seed/courier/200/200',
        lastMessage: '快递已放在门口快递柜',
        lastTime: '周二',
        unread: 0,
        online: true,
        messages: [
            { id: 601, type: 'text', content: '您好，有您的快递', time: '10:00', isMe: false },
            { id: 602, type: 'text', content: '好的，放门口就行', time: '10:02', isMe: true },
            { id: 603, type: 'image', content: 'https://picsum.photos/seed/package1/400/300', time: '10:05', isMe: false },
            { id: 604, type: 'text', content: '快递已放在门口快递柜，取件码1234', time: '10:06', isMe: false },
            { id: 605, type: 'text', content: '好的，谢谢', time: '10:10', isMe: true }
        ]
    },
    {
        id: 7,
        name: '赵六',
        avatar: 'https://picsum.photos/seed/zhaoliu/200/200',
        lastMessage: '太好看啦！在哪拍的？',
        lastTime: '周一',
        unread: 0,
        online: false,
        messages: [
            { id: 701, type: 'text', content: '你看我周末拍的照片', time: '20:00', isMe: false },
            { id: 702, type: 'image', content: 'https://picsum.photos/seed/photo1/400/300', time: '20:01', isMe: false },
            { id: 703, type: 'image', content: 'https://picsum.photos/seed/photo2/400/300', time: '20:01', isMe: false },
            { id: 704, type: 'image', content: 'https://picsum.photos/seed/photo3/400/300', time: '20:02', isMe: false },
            { id: 705, type: 'text', content: '太好看啦！在哪拍的？', time: '20:05', isMe: true },
            { id: 706, type: 'text', content: '在云南大理，风景特别好', time: '20:10', isMe: false }
        ]
    }
];

var currentChatId = null;
var currentChat = null;

function getTimeStr() {
    var now = new Date();
    return now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');
}

function formatDate(timestamp) {
    var date = new Date(timestamp);
    return date.getFullYear() + '年' + (date.getMonth() + 1) + '月' + date.getDate() + '日';
}

function renderChatList(filter) {
    var list = document.getElementById('chat-list');
    var data = chatData;

    if (filter) {
        filter = filter.toLowerCase();
        data = data.filter(function(c) {
            return c.name.toLowerCase().includes(filter);
        });
    }

    if (data.length === 0) {
        list.innerHTML = '<div style="text-align:center;padding:60px 20px;color:#8e8e93;font-size:15px;">没有找到相关对话</div>';
        return;
    }

    list.innerHTML = data.map(function(chat) {
        var preview = chat.lastMessage;
        if (preview === '[图片]') {
            preview = '<span style="color:#8e8e93;">[图片]</span>';
        }

        var unreadBadge = chat.unread > 0
            ? '<div class="chat-unread">' + (chat.unread > 99 ? '99+' : chat.unread) + '</div>'
            : '';

        var onlineDot = chat.online ? '<div class="online-dot"></div>' : '';

        return '' +
            '<div class="chat-item" onclick="openChat(' + chat.id + ')">' +
                '<div class="chat-avatar" style="background-image:url(' + chat.avatar + ')">' + onlineDot + '</div>' +
                '<div class="chat-info">' +
                    '<div class="chat-top">' +
                        '<div class="chat-name">' + chat.name + '</div>' +
                        '<div class="chat-time">' + chat.lastTime + '</div>' +
                    '</div>' +
                    '<div class="chat-bottom">' +
                        '<div class="chat-preview">' + preview + '</div>' +
                        unreadBadge +
                    '</div>' +
                '</div>' +
            '</div>';
    }).join('');
}

function openChat(chatId) {
    currentChatId = chatId;
    currentChat = chatData.find(function(c) { return c.id === chatId; });
    if (!currentChat) return;

    currentChat.unread = 0;

    var avatar = document.getElementById('detail-avatar');
    avatar.style.backgroundImage = 'url(' + currentChat.avatar + ')';

    document.getElementById('detail-name').textContent = currentChat.name;
    document.getElementById('detail-status').textContent = currentChat.online ? '在线' : '离线';

    renderMessages();

    document.getElementById('page-chat-list').classList.remove('active');
    document.getElementById('page-chat-detail').classList.add('active');

    renderChatList();
}

function renderMessages() {
    var container = document.getElementById('messages-list');
    if (!currentChat) return;

    var dateDivider = document.getElementById('date-divider');
    dateDivider.innerHTML = '<span class="date-divider-text">今天</span>';

    var html = '';
    var messageCount = currentChat.messages.length;

    for (var i = 0; i < messageCount; i++) {
        var msg = currentChat.messages[i];
        var isMe = msg.isMe;
        var isGroup = currentChat.isGroup;

        var bubbleClass = isMe ? 'sent' : 'received';
        var showAvatar = !isMe;

        html += '<div class="message ' + bubbleClass + '">';

        if (showAvatar) {
            html += '<div class="message-avatar" style="background-image:url(' + currentChat.avatar + ')"></div>';
        } else {
            html += '<div style="width:28px;flex-shrink:0;"></div>';
        }

        html += '<div class="message-group">';

        if (isGroup && !isMe && msg.sender) {
            html += '<div style="font-size:12px;color:#8e8e93;margin-bottom:2px;margin-left:4px;">' + msg.sender + '</div>';
        }

        if (msg.type === 'text') {
            html += '<div class="message-bubble">' + msg.content + '</div>';
        } else if (msg.type === 'image') {
            html += '<img class="message-image" src="' + msg.content + '" alt="图片" onclick="showImage(this.src)" onerror="this.style.display=\'none\'">';
        }

        html += '<div class="message-time">' + msg.time + (isMe ? ' <span class="message-status">✓</span>' : '') + '</div>';

        html += '</div></div>';
    }

    container.innerHTML = html;
    container.scrollTop = container.scrollHeight;

    var messagesContainer = document.getElementById('messages-container');
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function goBack() {
    document.getElementById('page-chat-detail').classList.remove('active');
    document.getElementById('page-chat-list').classList.add('active');
    currentChatId = null;
    currentChat = null;
}

function sendMessage() {
    var input = document.getElementById('message-input');
    var text = input.value.trim();
    if (!text || !currentChat) return;

    var msg = {
        id: Date.now(),
        type: 'text',
        content: text,
        time: getTimeStr(),
        isMe: true
    };

    currentChat.messages.push(msg);
    currentChat.lastMessage = text;
    currentChat.lastTime = getTimeStr();

    input.value = '';
    renderMessages();
    renderChatList();

    setTimeout(function() {
        autoReply();
    }, 1500 + Math.random() * 2000);
}

function autoReply() {
    if (!currentChat) return;

    var replies = [
        '嗯嗯', '好的', '哈哈', '收到', '对呀',
        '原来如此', '有道理', '真的吗？', '太棒了！', '明白了'
    ];
    var reply = replies[Math.floor(Math.random() * replies.length)];

    var msg = {
        id: Date.now(),
        type: 'text',
        content: reply,
        time: getTimeStr(),
        isMe: false
    };

    currentChat.messages.push(msg);
    currentChat.lastMessage = reply;
    currentChat.lastTime = getTimeStr();

    renderMessages();
    renderChatList();
}

function showImage(src) {
    var existing = document.querySelector('.image-overlay');
    if (existing) {
        existing.remove();
    }

    var overlay = document.createElement('div');
    overlay.className = 'image-overlay active';
    overlay.innerHTML = '<span class="close-overlay">&times;</span><img src="' + src + '" alt="图片">';
    overlay.onclick = function() {
        overlay.classList.remove('active');
        setTimeout(function() { overlay.remove(); }, 300);
    };
    document.body.appendChild(overlay);
}

function filterChats(value) {
    renderChatList(value);
}

function showCompose() {
    alert('新建短信');
}

function showContactInfo() {
    if (currentChat) {
        alert(currentChat.name + ' - 查看联系人信息');
    }
}

document.addEventListener('DOMContentLoaded', function() {
    renderChatList();

    var input = document.getElementById('message-input');
    input.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });
});

document.addEventListener('click', function(e) {
    var overlay = document.querySelector('.image-overlay.active');
    if (overlay && !e.target.closest('.image-overlay img') && !e.target.closest('.close-overlay')) {
        overlay.classList.remove('active');
        setTimeout(function() { overlay.remove(); }, 300);
    }
});