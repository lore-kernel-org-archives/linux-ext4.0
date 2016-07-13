From: Zhang AiHua <zhangaihua1@huawei.com>
Subject: FS: the /tmp can't be umounted!
Date: Wed, 13 Jul 2016 14:33:18 +0800
Message-ID: <5785E0AE.3050700@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

mount:
tmpfs on /tmp type tmpfs (rw)

then
mount -t ext4 /dev/sda3 /tmp
log as below:
Jul 13 03:54:10 localhost kernel: [   53.871354] mnt_add_count, n 1, count 2
Jul 13 03:54:10 localhost kernel: [   53.871360] mnt_add_count, n -1, count 1

then open a new window(the tool is SecureCRT , X86), the log as below:
Jul 13 03:54:37 localhost kernel: [   80.921236] unix_bind sun path /tmp/ssh-LzCqpMaVwG/agent.2754
Jul 13 03:54:37 localhost kernel: [   80.921250] unix_mknod sun path /tmp/ssh-LzCqpMaVwG/agent.2754
Jul 13 03:54:37 localhost kernel: [   80.921255] mnt_add_count, n 1, count 2
Jul 13 03:54:37 localhost kernel: [   80.921273] unix path ssh-LzCqpMaVwG


and the to umount /tmp:
[root@localhost ~]# umount /tmp
umount: /tmp: target is busy
         (In some cases useful info about processes that
          use the device is found by lsof(8) or fuser(1).)
[root@localhost ~]# lsof /tmp
[root@localhost ~]#


the mnt count was added because the operation of opening a new window,
so can't umount.

the stack as below:
Jul 12 04:01:44 localhost kernel: [  161.246002]  000000000000c1ff ffff880c466f1e38 ffffffff814cda07 ffff880c466f1e50
Jul 12 04:01:44 localhost kernel: [  161.246004]  ffffffff8116f23e ffff88183bc4ab40 ffff880c466f1ec8 ffffffff814a954e
Jul 12 04:01:44 localhost kernel: [  161.246006]  0000000000000286 00007fea553bb810 ffff881845562700 ffff881845562700
Jul 12 04:01:44 localhost kernel: [  161.246008] Call Trace:
Jul 12 04:01:44 localhost kernel: [  161.246011]  [<ffffffff814cda07>] dump_stack+0x19/0x1b
Jul 12 04:01:44 localhost kernel: [  161.246013]  [<ffffffff8116f23e>] mntget+0x5e/0x60
Jul 12 04:01:44 localhost kernel: [  161.246016]  [<ffffffff814a954e>] unix_bind+0x2ae/0x300
Jul 12 04:01:44 localhost kernel: [  161.246018]  [<ffffffff8140a55a>] SyS_bind+0x6a/0xa0
Jul 12 04:01:44 localhost kernel: [  161.246020]  [<ffffffff814dacfc>] ? tracesys+0x7e/0xe2
Jul 12 04:01:44 localhost kernel: [  161.246022]  [<ffffffff814dad5b>] tracesys+0xdd/0xe2

Is this a problem? How can I fix it?



