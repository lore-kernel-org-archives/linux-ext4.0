From: Dexuan Cui <decui@microsoft.com>
Subject: RE: Can one file system be R/W mounted multiple times in Linux?
Date: Fri, 9 Jan 2015 06:48:54 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C61EA7288F@SIXPRD3002MB028.064d.mgd.msft.net>
References: <F792CF86EFE20D4AB8064279AFBA51C61EA72765@SIXPRD3002MB028.064d.mgd.msft.net>
 <20150109035123.GG22149@ZenIV.linux.org.uk>
 <F792CF86EFE20D4AB8064279AFBA51C61EA727DE@SIXPRD3002MB028.064d.mgd.msft.net>
 <E09EF4B0-81D8-445C-B921-F920336200AC@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	"stefanha@redhat.com" <stefanha@redhat.com>
To: Eric Sandeen <esandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <E09EF4B0-81D8-445C-B921-F920336200AC@redhat.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> -----Original Message-----
> From: Eric Sandeen [mailto:esandeen@redhat.com]
> Sent: Friday, January 9, 2015 14:05 PM
> To: Dexuan Cui
> Cc: Al Viro; linux-fsdevel@vger.kernel.org; linux-ext4; stefanha@redhat.com
> Subject: Re: Can one file system be R/W mounted multiple times in Linux?
> 
> On Jan 8, 2015, at 10:59 PM, Dexuan Cui <decui@microsoft.com> wrote:
> 
> >> -----Original Message-----
> >> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> >> Sent: Friday, January 9, 2015 11:51 AM
> >> To: Dexuan Cui
> >> Cc: linux-fsdevel@vger.kernel.org; 'linux-ext4'; stefanha@redhat.com
> >> Subject: Re: Can one file system be R/W mounted multiple times in Linux?
> >>
> >>> On Fri, Jan 09, 2015 at 03:44:16AM +0000, Dexuan Cui wrote:
> >>> The 'mount' utility allows me to mount 1 file systems multiple times at
> >> different
> >>> mount points, like "mount /dev/sdb1 /a; mount /dev/sdb1 /b".
> >>>
> >>> I tried to write from /a and /b at the same time and it seems everything is
> OK
> >>> and no data corruption happens.
> >>> I tried only  ext4 only.
> >>>
> >>> Can somebody please tell me if this usage is safe?
> >>
> >> Yes.
> >
> > Thanks for the confirmation!
> >
> > -- Dexuan
> 
> But to be clear, just in case - this is completely different from, say, mounting the
> same ext4 fs on two different nodes on a SAN, which is quite certainly not safe...
> 
> -Eric

Thank Eric for pointing this out!
Can you please explain this?  I didn't use SAN... 

Thanks,
-- Dexuan
