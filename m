From: Karel Zak <kzak@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Mon, 12 Jan 2015 17:47:05 +0100
Message-ID: <20150112164705.GP20899@x2.net.home>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
 <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
 <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
 <20150112130058.GM20899@x2.net.home>
 <alpine.LFD.2.00.1501121514550.32312@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1501121514550.32312@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jan 12, 2015 at 03:20:19PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> that's not what I meant at all. Yes, things like MMP should help.
> But what I was suggesting was not FS specific.

And what do you want to do when somebody will implement any
cluster-like or multi-root filesystem where share the same FS image
between two loop devices is expected and supported feature?

I don't think there is any such generic VFS restriction, it's about FS
driver(s).

> mount(8) could in case of '-o loop' look whether there is already a
> block device associated with the file and if so use it instead of
> creating new one.
=20
mount(8) already checks if the same backing file is not mounted on the
same mountpoint

 # mount -o loop fs.img /mnt/A
 # mount -o loop fs.img /mnt/A
 mount: fs.img is already mounted

but I don't want to make decision about anything else in userspace.

    Karel

--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
