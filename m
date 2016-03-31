From: Kurt Seifried <kseifried-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CVE Request - Linux kernel (multiple versions)
 ext2/ext3 filesystem DoS
Date: Thu, 31 Mar 2016 08:53:17 -0600
Message-ID: <CANO=Ty1OcZ=ukxttq9A9M9ot78jDPzDmq4y1NGUMAQmSiveH_g@mail.gmail.com>
References: <f4df42b35dd9a6c8c6851eba66b2b3f1.squirrel@webmail-etu.univ-nantes.fr>
	<1459286067.2596.18.camel@debian.org>
	<57514A3C-DBAD-4E5E-98EA-23E490629C02@dilger.ca>
	<20160330204304.GD6207@thunk.org>
Reply-To: oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=94eb2c0b01e639bb21052f596c9e
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Yves-Alexis Perez <corsac-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>,
	Theodore Tso <tytso-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oss-security <oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
Return-path: <oss-security-return-19185-gcsos-oss-security=m.gmane.org-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Post: <mailto:oss-security-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Help: <mailto:oss-security-help-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <mailto:oss-security-unsubscribe-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
List-Subscribe: <mailto:oss-security-subscribe-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org>
In-Reply-To: <20160330204304.GD6207-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

--94eb2c0b01e639bb21052f596c9e
Content-Type: text/plain; charset=UTF-8

On Wed, Mar 30, 2016 at 2:43 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
>
>
> You can mount the file system with "mount -o errors=continue" and this
> will override the default behavior specified in the super block.
>
> I would argue that a Desktop or server system that had automount
> should either (a) mount with -o errors=continue, or (b) force an fsck
> on the file system before mounting it.
>

The problem is that:

a) means I'll be mounting filesystems with errors that I may want to know
about (but not have my  system panic about)

b) fsck takes a long time on large disks (the smallest size of disk I buy
for USB drives is 1TB, if I fsck every time I plug one in I'll die of old
age).


>
> So I think this is a particularly meaningless CVE, which is why I have
> zero respect for people who try to make any kind of conclusion based
> on CVE counts.   I certainly don't plan to do anything about this.
>

As for your comments on CVE counting even the then head of CVE @mitre told
people not to rely on CVE counting for vulnerability stats:

https://media.blackhat.com/us-13/US-13-Martin-Buying-Into-The-Bias-Why-Vulnerability-Statistics-Suck-Slides.pdf

As for your comment on not fixing this: I think fundamentally I should be
able to plug a file system in and try to mount it with default/reasonable
options and NOT have my system panic. File system handling code, like any
code that handles user supplied data should be able to handle garbage
gracefully and securely. At worst it should try to mount and go "derp, it's
messed up, maybe fsck it?"


>
>                                            - Ted
>



-- 

--
Kurt Seifried -- Red Hat -- Product Security -- Cloud
PGP A90B F995 7350 148F 66BF 7554 160D 4553 5E26 7993
Red Hat Product Security contact: secalert-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--94eb2c0b01e639bb21052f596c9e--
