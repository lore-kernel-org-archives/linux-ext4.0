From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Mon, 12 Jan 2015 15:20:19 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1501121514550.32312@localhost.localdomain>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net> <20150109035123.GG22149@ZenIV.linux.org.uk> <20150109120159.GA20300@stefanha-thinkpad.redhat.com> <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
 <20150112130058.GM20899@x2.net.home>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1782268035-1421072426=:32312"
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Dexuan Cui <decui@microsoft.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"'linux-ext4'" <linux-ext4@vger.kernel.org>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150112130058.GM20899@x2.net.home>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1782268035-1421072426=:32312
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 12 Jan 2015, Karel Zak wrote:

> Date: Mon, 12 Jan 2015 14:00:58 +0100
> From: Karel Zak <kzak@redhat.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>,
>     Dexuan Cui <decui@microsoft.com>,
>     "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
>     'linux-ext4' <linux-ext4@vger.kernel.org>
> Subject: Re: Can one file system be R/W mounted multiple times in Linux?
> 
> On Fri, Jan 09, 2015 at 04:52:11PM +0100, Lukáš Czerner wrote:
> > Now the question is, whether 'mount' can be a bit smarter than that
> > and just mount the already existing block device instead of creating
> > new one ? Karel ?
> 
> Well, the question is how smart is too smart :-) And Al is right, problem
> is in races.
> 
> Anyway, I'd like to avoid complex FS specific code in mount(8). IMHO
> it's FS driver responsibility to avoid (or support) FS sharing between
> more block devices.
> 
> BTW, for ext4 you can enable ETX4_FEATURE_INCOMPAT_MMP to protect
> against multi-mount.
> 
>     Karel

Hi Karel,

that's not what I meant at all. Yes, things like MMP should help.
But what I was suggesting was not FS specific.

mount(8) could in case of '-o loop' look whether there is already a
block device associated with the file and if so use it instead of
creating new one.

However this might race with device removal among other things and I
am not sure whether there is any easy solution.

Thanks!
-Lukas
--8323328-1782268035-1421072426=:32312--
