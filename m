From: Karel Zak <kzak@redhat.com>
Subject: Re: Can one file system be R/W mounted multiple times in Linux?
Date: Mon, 12 Jan 2015 14:00:58 +0100
Message-ID: <20150112130058.GM20899@x2.net.home>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
 <20150109120159.GA20300@stefanha-thinkpad.redhat.com>
 <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
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
In-Reply-To: <alpine.LFD.2.00.1501091646400.24821@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jan 09, 2015 at 04:52:11PM +0100, Luk=C3=A1=C5=A1 Czerner wrote=
:
> Now the question is, whether 'mount' can be a bit smarter than that
> and just mount the already existing block device instead of creating
> new one ? Karel ?

Well, the question is how smart is too smart :-) And Al is right, probl=
em
is in races.

Anyway, I'd like to avoid complex FS specific code in mount(8). IMHO
it's FS driver responsibility to avoid (or support) FS sharing between
more block devices.

BTW, for ext4 you can enable ETX4_FEATURE_INCOMPAT_MMP to protect
against multi-mount.

    Karel

--=20
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
