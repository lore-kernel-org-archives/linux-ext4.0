From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: e2fsprogs alignment issues
Date: Wed, 11 Jul 2012 10:04:51 -0500
Message-ID: <4FFD9613.3050305@redhat.com>
References: <4FFD7D9B.2080503@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265Ab2GKPFj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jul 2012 11:05:39 -0400
In-Reply-To: <4FFD7D9B.2080503@bobich.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/11/12 8:20 AM, Gordan Bobic wrote:
> I would like to bring the following bug report to people's
> attention:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=680090
> 
> The issue is that the code used in e2fsprogs WRT allocating unaligned
> buffers and then casting them into structs is non-portable and
> dangerous - eyewateringly dangerous in something like e2fsprogs where
> it can lead to thorough trashing of the file system.
> 
> Can something be done to improve the portability of the userspace
> code?
> 
> The issue has been discussed on the Fedora-ARM mailing list: 
> http://lists.fedoraproject.org/pipermail/arm/2012-July/003637.html 
> but the argument there was that the issue needs to be fixed upstream,
> hence why I am posting it here.
> 
> This is an issue on all ARMs up to ARMv5, possibly ARMv6, and likely
> other CPU architectures that don't have transparent alignment fixup
> in hardware (Itanium, SPARC, probably others).
> 
> Apart from being dangerous, using unaligned arrays also affects
> performance because it leads to data needlessly straddling cache
> lines in the CPU. But that doesn't really matter in this case.

For what it's worth, I've never seen reports from anywhere that indicate
that it didn't get fixed up.  But I agree that if we can eliminate the need
for the fixups it'd be best.

Many of these are the result of things like:

        char buf[4096] = "";
        struct fiemap *fiemap = (struct fiemap *)buf;


Ted, is this construct just an attempt to avoid malloc/free for
simplicity of the code?  I think Gordan suggested (if I understand it
right) that doing an array of ints might also solve the problem, since
ints should be on natural alignment.  Or maybe in some cases malloc/free
would be more obvious, if handling errors isn't too tricky.

Gordan, until I get handy access to a real arm box, if you could do a
"make check" in the e2fsprogs tree, it might flush out a few more
of these alignment warnings, and adding them all to the bug for tracking
purposes might be helpful.

(IIRC "make gcc-wall" will also emit warnings for casts which change
natural alignment, among other things)

Thanks,

-Eric


> Many thanks.

