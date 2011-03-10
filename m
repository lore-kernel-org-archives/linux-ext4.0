From: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [Ext4 punch hole 1/5] Ext4 Punch Hole Support: Convert Blocks to
 Uninit Exts
Date: Thu, 10 Mar 2011 13:40:13 +0800
Message-ID: <AANLkTikvw7AEPdLtfc6+4KpJQHM8maACsh1+s9P6==kB@mail.gmail.com>
References: <4D6C6318.2010105@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51902 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1CJFkO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Mar 2011 00:40:14 -0500
Received: by qyg14 with SMTP id 14so1135125qyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 09 Mar 2011 21:40:13 -0800 (PST)
In-Reply-To: <4D6C6318.2010105@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 1, 2011 at 11:08 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi All!
>
> This is the patch series for ext4 punch hole that I have been working=
 on.
> There is still a little more debugging that I would like to do with i=
t,
> but I've had some requests to see the patch, so I'm sending it out a =
bit
> early. =C2=A0Any feed back is appreciated. =C2=A0Thx!
>

Hi, aliison

Do you have new version of the patchset which address the comments here=
?
If they are not ready to send to list, you can send to me, I would like=
 to test.

I tested this patchset for kvm guest image cleanup.
Host ext4 + guest ext4
guest side use lukas's fstrim tool, host side use a modified version
of Christoph's qemu block discard patch

there's many error like following:
[62834.936374] EXT4-fs error (device sda7): ext4_ext_lookup_hole:2907:
inode #1310744: comm qemu-system-x86: bad header/extent: invalid magic
- magic 0, entries 0, max 256(0), depth 256(0)
[62834.936616] EXT4-fs error (device sda7): ext4_ext_lookup_hole:2907:
inode #1310744: comm qemu-system-x86: bad header/extent: invalid magic
- magic 0, entries 0, max 256(0), depth 256(0)
bad header/extent: invalid magic - magic 0, entries 0, max 256(0), dept=
h 256(0)
Then host pc hangs there.

BTW, host xfs + guest ext4 works well for me.

--
Thanks
Dave
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
