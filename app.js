var emojiSets = {
    faces: ["😀","😃","😄","😁","😅","😂","🤣","🥲","😊","😇","🙂","😉","😌","😍","🥰","😘","😋","🤪","😜","😝","😎","🤩","🥳","😏","😒","😔","😟","😕","🙁","☹️","😣","😖","😫","😩","🥺","😢","😭","😤","😡","🤬","😱","😨","😰","😥","😓","🤗","🤔","🤭","🤫","🤥","😶","😐","😑","😬","🙄","😯","😦","😧","😮","😲","🥱","😴","🤤","😪","😵","🤐","🥴","🤢","🤮","🤧","😷","🤒","🤕","🤑","🤠","😈","👿","👹","👺","🤡","💩","👻","💀","☠️","👽","👾","🤖","🎃","😺","😸","😹","😻","😼","😽","🙀","😿","😾"],
    gestures: ["👋","🤚","🖐️","✋","🖖","👌","🤌","🤏","✌️","🤞","🤟","🤘","🤙","👈","👉","👆","🖕","👇","☝️","👍","👎","✊","👊","🤛","🤜","👏","🙌","👐","🤲","🤝","🙏","✍️","💅","🤳","💪","🦾","🦵","🦿","🦶","👂","🦻","👃","🧠","🫀","🫁","🦷","🦴","👀","👁️","👅","👄","💋","🩸"],
    nature: ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨","🐯","🦁","🐮","🐷","🐸","🐵","🙈","🙉","🙊","🐒","🦍","🐔","🐧","🐦","🐤","🐣","🐥","🦆","🦅","🦉","🦇","🐺","🐗","🐴","🦄","🐝","🐛","🦋","🐌","🐞","🐜","🦟","🦗","🕷️","🦂","🐢","🐍","🦎","🦖","🦕","🐙","🦑","🦐","🐠","🐟","🐡","🦈","🐳","🐋","🐬","🦭","🐊","🐅","🐆","🦓","🦍","🦧","🐘","🦛","🦏","🐪","🐫","🦒","🐃","🐂","🐄","🐎","🐖","🐏","🐑","🦙","🐐","🦌","🐕","🐩","🦮","🐈","🐓","🦃","🦚","🦜","🦢","🦩","🕊️","🌸","💮","🏵️","🌹","🥀","🌺","🌻","🌼","🌷","🌱","🪴","🌲","🌳","🌴","🌵","🌾","🌿","☘️","🍀","🍁","🍂","🍃"],
    food: ["🍏","🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🫐","🍈","🍒","🍑","🥭","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥬","🥒","🌶️","🫑","🌽","🥕","🫒","🧄","🧅","🥔","🍠","🥐","🍞","🥖","🥨","🧀","🥚","🍳","🧈","🥞","🧇","🥓","🥩","🍗","🍖","🦴","🌭","🍔","🍟","🍕","🫓","🥪","🥙","🧆","🌮","🌯","🫔","🥗","🥘","🫕","🥫","🍝","🍜","🍲","🍛","🍣","🍱","🥟","🦪","🍤","🍙","🍚","🍘","🍥","🥠","🥮","🍢","🍡","🍧","🍨","🍦","🥧","🧁","🍰","🎂","🍮","🍭","🍬","🍫","🍿","🍩","🍪","🌰","🥜","🍯","🥛","🍼","🫖","☕","🍵","🧃","🥤","🧋","🍶","🍺","🍻","🥂","🍷","🥃","🍸","🍹","🧉","🍾","🧊","🥄","🍴","🍽️","🥣","🥡","🥢","🧂"],
    objects: ["⌚","📱","💻","⌨️","🖥️","🖨️","🖱️","🖲️","🕹️","🗜️","💽","💾","💿","📀","📼","📷","📸","📹","🎥","📽️","🎞️","📞","☎️","📟","📠","📺","📻","🎙️","🎚️","🎛️","🧭","⏱️","⏲️","⏰","🕰️","⌛","📡","🔋","🔌","💡","🔦","🕯️","🪔","🧯","🗑️","🛢️","💸","💵","💴","💶","💷","🪙","💰","💳","💎","⚖️","🪜","🧰","🪛","🔧","🔨","⚒️","🛠️","⛏️","🪚","🔩","⚙️","🪤","🧱","⛓️","🧲","🔫","💣","🧨","🪓","🔪","🗡️","⚔️","🛡️","🚬","⚰️","🪦","⚱️","🏺","🔮","📿","🧿","💈","⚗️","🔭","🔬","🕳️","🩹","🩺","💊","💉","🩸","🧬","🦠","🧫","🧪","🌡️","🧹","🧺","🧻","🚽","🚿","🛁","🪥","🪒","🧴","🧷","🧹","🧽","🧼","🪣","🧯"],
    symbols: ["❤️","🧡","💛","💚","💙","💜","🖤","🤍","🤎","💔","❣️","💕","💞","💓","💗","💖","💘","💝","💟","☮️","✝️","☪️","🕉️","☸️","✡️","🔯","🕎","☯️","☦️","🛐","⛎","♈","♉","♊","♋","♌","♍","♎","♏","♐","♑","♒","♓","🆔","⚛️","🉑","☢️","☣️","📴","📳","🈶","🈚","🈸","🈺","🈷️","✴️","🆚","💮","🉐","㊙️","㊗️","🈴","🈵","🈹","🈲","🅰️","🅱️","🆎","🆑","🅾️","🆘","❌","⭕","🛑","⛔","📛","🚫","💯","💢","♨️","🚷","🚯","🚳","🚱","🔞","📵","🚭","❗","❕","❓","❔","‼️","⁉️","🔅","🔆","〽️","⚠️","🚸","🔱","⚜️","🔰","♻️","✅","🈯","💹","❇️","✳️","❎","🌐","💠","Ⓜ️","🌀","💤","🏧","🚾","♿","🅿️","🛗","🈳","🈂️","🛂","🛃","🛄","🛅","🚹","🚺","🚼","⚧","🚻","🚮","🎦","📶","🈁","🔣","ℹ️","🔤","🔡","🔠","🆖","🆗","🆙","🆒","🆕","🆓","0️⃣","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","🔟","🔢","#️⃣","*️⃣","⏏️","▶️","⏸️","⏯️","⏹️","⏺️","⏭️","⏮️","⏩","⏪","⏫","⏬","◀️","🔼","🔽","➡️","⬅️","⬆️","⬇️","↗️","↘️","↙️","↖️","↕️","↔️","↪️","↩️","⤴️","⤵️","🔀","🔁","🔂","🔄","🔃","🎵","🎶","➕","➖","➗","✖️","🟰","♾️","💲","💱","™️","©️","®️","〰️","➰","➿","🔚","🔙","🔛","🔝","🔜","✔️","☑️","🔘","🔴","🟠","🟡","🟢","🔵","🟣","⚫","⚪","🟤","🔺","🔻","🔸","🔹","🔶","🔷","🔳","🔲","▪️","▫️","◾","◽","◼️","◻️","🟥","🟧","🟨","🟩","🟦","🟪","⬛","⬜","🟫","🔈","🔇","🔉","🔊","🔔","🔕","📣","📢","👁‍🗨","💬","💭","🗯","♠️","♣️","♥️","♦️","🃏","🎴","🀄","🕐","🕑","🕒","🕓","🕔","🕕","🕖","🕗","🕘","🕙","🕚","🕛","🕜","🕝","🕞","🕟","🕠","🕡","🕢","🕣","🕤","🕥","🕦","🕧"],
    flags: ["🏳️","🏴","🏁","🚩","🎌","🏴‍☠️","🇦🇨","🇦🇩","🇦🇪","🇦🇫","🇦🇬","🇦🇮","🇦🇱","🇦🇲","🇦🇴","🇦🇶","🇦🇷","🇦🇸","🇦🇹","🇦🇺","🇦🇼","🇦🇽","🇦🇿","🇧🇦","🇧🇧","🇧🇩","🇧🇪","🇧🇫","🇧🇬","🇧🇭","🇧🇮","🇧🇯","🇧🇱","🇧🇲","🇧🇳","🇧🇴","🇧🇶","🇧🇷","🇧🇸","🇧🇹","🇧🇼","🇧🇾","🇧🇿","🇨🇦","🇨🇨","🇨🇩","🇨🇫","🇨🇬","🇨🇭","🇨🇮","🇨🇰","🇨🇱","🇨🇲","🇨🇳","🇨🇴","🇨🇵","🇨🇷","🇨🇺","🇨🇻","🇨🇼","🇨🇽","🇨🇾","🇨🇿","🇩🇪","🇩🇯","🇩🇰","🇩🇲","🇩🇴","🇩🇿","🇪🇨","🇪🇪","🇪🇬","🇪🇭","🇪🇷","🇪🇸","🇪🇹","🇪🇺","🇫🇮","🇫🇯","🇫🇰","🇫🇲","🇫🇴","🇫🇷","🇬🇦","🇬🇧","🇬🇩","🇬🇪","🇬🇫","🇬🇬","🇬🇭","🇬🇮","🇬🇱","🇬🇲","🇬🇳","🇬🇵","🇬🇶","🇬🇷","🇬🇸","🇬🇹","🇬🇺","🇬🇼","🇬🇾","🇭🇰","🇭🇲","🇭🇳","🇭🇷","🇭🇹","🇭🇺","🇮🇨","🇮🇩","🇮🇪","🇮🇱","🇮🇲","🇮🇳","🇮🇴","🇮🇶","🇮🇷","🇮🇸","🇮🇹","🇯🇪","🇯🇲","🇯🇴","🇯🇵","🇰🇪","🇰🇬","🇰🇭","🇰🇮","🇰🇲","🇰🇳","🇰🇵","🇰🇷","🇰🇼","🇰🇾","🇰🇿","🇱🇦","🇱🇧","🇱🇨","🇱🇮","🇱🇰","🇱🇷","🇱🇸","🇱🇹","🇱🇺","🇱🇻","🇱🇾","🇲🇦","🇲🇨","🇲🇩","🇲🇪","🇲🇫","🇲🇬","🇲🇭","🇲🇰","🇲🇱","🇲🇲","🇲🇳","🇲🇴","🇲🇵","🇲🇶","🇲🇷","🇲🇸","🇲🇹","🇲🇺","🇲🇻","🇲🇼","🇲🇽","🇲🇾","🇲🇿","🇳🇦","🇳🇨","🇳🇪","🇳🇫","🇳🇬","🇳🇮","🇳🇱","🇳🇴","🇳🇵","🇳🇷","🇳🇺","🇳🇿","🇴🇲","🇵🇦","🇵🇪","🇵🇫","🇵🇬","🇵🇭","🇵🇰","🇵🇱","🇵🇲","🇵🇳","🇵🇷","🇵🇸","🇵🇹","🇵🇼","🇵🇾","🇶🇦","🇷🇪","🇷🇴","🇷🇸","🇷🇺","🇷🇼","🇸🇦","🇸🇧","🇸🇨","🇸🇩","🇸🇪","🇸🇬","🇸🇭","🇸🇮","🇸🇯","🇸🇰","🇸🇱","🇸🇲","🇸🇳","🇸🇴","🇸🇷","🇸🇸","🇸🇹","🇸🇻","🇸🇽","🇸🇾","🇸🇿","🇹🇦","🇹🇨","🇹🇩","🇹🇫","🇹🇬","🇹🇭","🇹🇯","🇹🇰","🇹🇱","🇹🇲","🇹🇳","🇹🇴","🇹🇷","🇹🇹","🇹🇻","🇹🇼","🇹🇿","🇺🇦","🇺🇬","🇺🇳","🇺🇸","🇺🇾","🇺🇿","🇻🇦","🇻🇨","🇻🇪","🇻🇬","🇻🇮","🇻🇳","🇻🇺","🇼🇫","🇼🇸","🇽🇰","🇾🇪","🇾🇹","🇿🇦","🇿🇲","🇿🇼"]
};

var currentEmojiCat = 'faces';
var currentChat = null;
var searchTimeout = null;

function getNow() {
    var d = new Date();
    return d.getHours().toString().padStart(2,'0') + ':' + d.getMinutes().toString().padStart(2,'0');
}

function fmtDate(ts) {
    var d = new Date(ts);
    var months = ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'];
    return d.getFullYear() + '年' + months[d.getMonth()] + d.getDate() + '日';
}

var chatData = [
    {
        id: 1, name: 'EX', avatar: 'https://picsum.photos/seed/exchat/200/200',
        lastMsg: '好吧', lastTime: '19:39', unread: 0, pinned: false,
        messages: [
            {id:101,text:'我对这个男的是真心我不管他有没有钱',time:'19:39',me:false,status:'read'},
            {id:102,text:'对你只是圈',time:'19:39',me:false,status:'read'},
            {id:103,text:'好吧',time:'19:39',me:true,status:'read'}
        ]
    },
    {
        id: 2, name: '张三', avatar: 'https://picsum.photos/seed/zhangsan2/200/200',
        lastMsg: '哈哈哈没问题', lastTime: '10:55', unread: 0, pinned: false,
        messages: [
            {id:201,text:'周末有空吗？一起吃个饭',time:'10:32',me:false,status:'read'},
            {id:202,text:'好啊，在哪？',time:'10:35',me:true,status:'read'},
            {id:203,text:'老地方，下午6点',time:'10:38',me:false,status:'read'},
            {id:204,text:'没问题，到时候见',time:'10:50',me:true,status:'read'},
            {id:205,text:'哈哈哈没问题',time:'10:55',me:false,status:'delivered'}
        ]
    },
    {
        id: 3, name: '妈妈', avatar: 'https://picsum.photos/seed/momchat/200/200',
        lastMsg: '记得多喝水', lastTime: '昨天', unread: 0, pinned: true,
        messages: [
            {id:301,text:'儿子吃饭了吗',time:'12:00',me:false,status:'read'},
            {id:302,text:'吃了妈，你呢',time:'12:05',me:true,status:'read'},
            {id:303,text:'我也吃了，今天做了红烧肉',time:'12:10',me:false,status:'read'},
            {id:304,text:'周末回来吃吗',time:'12:12',me:false,status:'read'},
            {id:305,text:'这周可能加班，下周回去吧',time:'12:15',me:true,status:'read'},
            {id:306,text:'好吧，照顾好自己',time:'12:20',me:false,status:'read'},
            {id:307,text:'记得多喝水',time:'18:00',me:false,status:'delivered'}
        ]
    },
    {
        id: 4, name: '公司群', avatar: 'https://picsum.photos/seed/cochat/200/200',
        lastMsg: '收到，谢谢', lastTime: '周一', unread: 0, pinned: false,
        messages: [
            {id:401,text:'@所有人 明天下午3点开会',time:'15:00',me:false,status:'read'},
            {id:402,text:'收到',time:'15:02',me:true,status:'read'},
            {id:403,text:'收到',time:'15:03',me:false,status:'read'},
            {id:404,text:'好的',time:'15:04',me:false,status:'read'}
        ]
    },
    {
        id: 5, name: '李四', avatar: 'https://picsum.photos/seed/lisichat/200/200',
        lastMsg: '那个项目方案我发你看看', lastTime: '周三', unread: 2, pinned: false,
        messages: [
            {id:501,text:'在吗',time:'14:20',me:false,status:'read'},
            {id:502,text:'那个项目方案我发你看看',time:'14:21',me:false,status:'delivered'}
        ]
    },
    {
        id: 6, name: '赵六', avatar: 'https://picsum.photos/seed/zhaoliu/200/200',
        lastMsg: '照片拍得真不错！', lastTime: '周日', unread: 0, pinned: false,
        messages: [
            {id:601,text:'看我周末拍的照片',time:'20:00',me:false,status:'read'},
            {id:602,text:'真好看！在哪拍的',time:'20:05',me:true,status:'read'},
            {id:603,text:'照片拍得真不错！',time:'20:10',me:false,status:'delivered'}
        ]
    },
    {
        id: 7, name: '王五', avatar: 'https://picsum.photos/seed/wangwuchat/200/200',
        lastMsg: '周末一起去打球？', lastTime: '上周二', unread: 0, pinned: false,
        messages: [
            {id:701,text:'周末一起去打球？',time:'15:00',me:false,status:'read'},
            {id:702,text:'可以啊，几点',time:'15:05',me:true,status:'read'},
            {id:703,text:'下午3点，老地方',time:'15:10',me:false,status:'read'},
            {id:704,text:'没问题',time:'15:12',me:true,status:'read'}
        ]
    }
];

function renderChatList(filter) {
    var list = document.getElementById('chat-list');
    var data = chatData;
    if (filter) {
        filter = filter.toLowerCase();
        data = data.filter(function(c){return c.name.toLowerCase().includes(filter) || c.lastMsg.toLowerCase().includes(filter)});
    }
    if (data.length === 0) {
        list.innerHTML = '<div style="text-align:center;padding:60px;color:#8E8E93;font-size:16px">没有找到结果</div>';
        return;
    }

    var pinned = data.filter(function(c){return c.pinned});
    var unpinned = data.filter(function(c){return !c.pinned});

    var html = '';
    var secTitle = '';

    if (pinned.length) {
        html += '<div style="padding:8px 16px 4px;font-size:13px;color:#8E8E93;font-weight:500">置顶</div>';
        pinned.forEach(function(c){ html += chatItemHTML(c); });
    }

    if (unpinned.length) {
        if (pinned.length) {
            html += '<div style="padding:12px 16px 4px;font-size:13px;color:#8E8E93;font-weight:500">消息</div>';
        }
        unpinned.forEach(function(c){ html += chatItemHTML(c); });
    }

    list.innerHTML = html;
}

function chatItemHTML(c) {
    var preview = c.lastMsg;
    var unread = c.unread > 0 ? '<div class="chat-unread">' + (c.unread > 99 ? '99+' : c.unread) + '</div>' : '';
    return '<div class="chat-item" onclick="openChat(' + c.id + ')">' +
        '<div class="chat-avatar" style="background-image:url(' + c.avatar + ')"></div>' +
        '<div class="chat-info">' +
            '<div class="chat-top">' +
                '<span class="chat-name">' + c.name + '</span>' +
                '<span class="chat-time">' + c.lastTime + '</span>' +
            '</div>' +
            '<div class="chat-bottom">' +
                '<span class="chat-preview">' + preview + '</span>' +
                unread +
            '</div>' +
        '</div>' +
    '</div>';
}

function openChat(id) {
    currentChat = chatData.find(function(c){return c.id === id});
    if (!currentChat) return;
    currentChat.unread = 0;

    document.getElementById('detail-avatar').style.backgroundImage = 'url(' + currentChat.avatar + ')';
    document.getElementById('detail-name').textContent = currentChat.name;
    document.getElementById('detail-status').textContent = '正在输入...';
    setTimeout(function(){ document.getElementById('detail-status').textContent = '在线'; }, 3000);

    renderMessages();
    document.getElementById('page-list').classList.remove('active');
    document.getElementById('page-detail').classList.add('active');
    renderChatList();
    closeEmojiPicker();

    setTimeout(function() {
        var mc = document.getElementById('messages-container');
        mc.scrollTop = mc.scrollHeight;
    }, 50);
}

function goBack() {
    document.getElementById('page-detail').classList.remove('active');
    document.getElementById('page-list').classList.add('active');
    closeEmojiPicker();
    currentChat = null;
    renderChatList();
}

function renderMessages() {
    var list = document.getElementById('messages-list');
    if (!currentChat) return;

    var msgs = currentChat.messages;
    var html = '';

    var groups = [];
    var curGroup = null;
    var curDate = '';

    for (var i = 0; i < msgs.length; i++) {
        var m = msgs[i];
        if (i === 0 || !curGroup || curGroup[0].me !== m.me) {
            if (curGroup) groups.push(curGroup);
            curGroup = [m];
        } else {
            curGroup.push(m);
        }
    }
    if (curGroup) groups.push(curGroup);

    for (var gi = 0; gi < groups.length; gi++) {
        var g = groups[gi];
        var first = g[0];

        html += '<div class="date-divider"><span class="date-divider-text">' + fmtDate(Date.now()) + '</span></div>';

        for (var mi = 0; mi < g.length; mi++) {
            var msg = g[mi];
            var cssClass = msg.me ? 'sent' : 'received';
            if (mi === 0) cssClass += ' msg-first';
            else cssClass += ' msg-next';
            if (mi === g.length - 1) cssClass += ' msg-last';

            html += '<div class="message ' + cssClass + '">';
            html += '<div class="bubble">' + msg.text + '</div>';
            html += '</div>';
        }

        if (g[g.length-1].me && g[g.length-1].status === 'read') {
            html += '<div class="read-receipt">已读 <span style="margin-left:4px;color:#8E8E93">' + g[g.length-1].time + '</span></div>';
        } else if (g[g.length-1].me && g[g.length-1].status === 'delivered') {
            html += '<div class="read-receipt delivered">已发送 <span style="margin-left:4px">' + g[g.length-1].time + '</span></div>';
        } else if (g[g.length-1].me) {
            html += '<div class="read-receipt delivered">已发送 <span style="margin-left:4px">' + g[g.length-1].time + '</span></div>';
        }
    }

    list.innerHTML = html;

    setTimeout(function() {
        var mc = document.getElementById('messages-container');
        mc.scrollTop = mc.scrollHeight;
    }, 10);
}

function sendMessage() {
    var input = document.getElementById('message-input');
    var text = input.value.trim();
    if (!text || !currentChat) return;

    var msg = {id: Date.now(), text: text, time: getNow(), me: true, status: 'delivered'};
    currentChat.messages.push(msg);
    currentChat.lastMsg = text;
    currentChat.lastTime = getNow();

    input.value = '';
    onInputChange();
    renderMessages();
    renderChatList();
    closeEmojiPicker();

    setTimeout(function() {
        var mc = document.getElementById('messages-container');
        mc.scrollTop = mc.scrollHeight;
    }, 20);

    setTimeout(function() {
        if (currentChat && currentChat.messages.length > 0 &&
            currentChat.messages[currentChat.messages.length-1].id === msg.id) {
            msg.status = 'read';
            currentChat.lastMsg = text;
            renderMessages();
            renderChatList();
        }
    }, 1500);

    setTimeout(function() { autoReply(); }, 2000 + Math.random() * 2000);
}

function autoReply() {
    if (!currentChat) return;
    var replies = ['嗯','好的','哈哈','收到','对呀','明白了','有道理','知道了','👌','😂','好吧','😅','👍','原来如此','太棒了','🤔','可以的'];
    var r = replies[Math.floor(Math.random() * replies.length)];

    var msg = {id: Date.now(), text: r, time: getNow(), me: false, status: 'read'};
    currentChat.messages.push(msg);
    currentChat.lastMsg = r;
    currentChat.lastTime = getNow();

    renderMessages();
    renderChatList();

    setTimeout(function() {
        var mc = document.getElementById('messages-container');
        mc.scrollTop = mc.scrollHeight;
    }, 20);
}

function onInputChange() {
    var input = document.getElementById('message-input');
    var btn = document.getElementById('send-btn');
    btn.disabled = input.value.trim().length === 0;
}

/* ===== Emoji Picker ===== */
var emojiOpen = false;
function toggleEmojiPicker() {
    emojiOpen = !emojiOpen;
    var picker = document.getElementById('emoji-picker');
    if (emojiOpen) {
        picker.classList.add('open');
        renderEmojiGrid();
    } else {
        picker.classList.remove('open');
    }
    document.getElementById('message-input').focus();
}

function closeEmojiPicker() {
    emojiOpen = false;
    document.getElementById('emoji-picker').classList.remove('open');
}

function renderEmojiGrid() {
    var grid = document.getElementById('emoji-grid');
    var emojis = emojiSets[currentEmojiCat] || emojiSets.faces;
    var html = '';
    for (var i = 0; i < emojis.length; i++) {
        html += '<button class="emoji-item" onclick="insertEmoji(\'' + emojis[i] + '\')">' + emojis[i] + '</button>';
    }
    grid.innerHTML = html;
}

function insertEmoji(e) {
    var input = document.getElementById('message-input');
    input.value += e;
    input.focus();
    onInputChange();
}

function toggleAppPicker() {}

document.addEventListener('DOMContentLoaded', function() {
    renderChatList();

    document.getElementById('search-input').addEventListener('input', function() {
        clearTimeout(searchTimeout);
        var v = this.value;
        searchTimeout = setTimeout(function(){ renderChatList(v); }, 200);
    });

    var catBtns = document.querySelectorAll('.emoji-cat-btn');
    for (var i = 0; i < catBtns.length; i++) {
        catBtns[i].addEventListener('click', function() {
            var cat = this.dataset.cat;
            if (cat === 'back') {
                closeEmojiPicker();
                return;
            }
            catBtns.forEach(function(b){b.classList.remove('active')});
            this.classList.add('active');
            currentEmojiCat = cat;
            renderEmojiGrid();
        });
    }
});
