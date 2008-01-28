From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Integrating patches in SLES10 e2fsprogs
Date: Sun, 27 Jan 2008 23:43:33 -0600
Message-ID: <479D6B85.2090403@redhat.com>
References: <20080124211728.GA24900@webber.adilger.int> <n7xir1iq69b.fsf@sor.suse.de> <20080127050543.GC24842@mit.edu> <479C9E13.8040209@redhat.com> <20080127202725.GA2545@mit.edu> <479D5CB9.5060801@redhat.com> <20080128052415.GA23482@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Matthias Koenig <mkoenig@suse.de>, linux-ext4@vger.kernel.org,
	hvogel@suse.de, Girish Shilamkar <Girish.Shilamkar@Sun.COM>,
	Eric Sandeen <esandeen@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbYA1Fn6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2008 00:43:58 -0500
In-Reply-To: <20080128052415.GA23482@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Sun, Jan 27, 2008 at 10:40:25PM -0600, Eric Sandeen wrote:
>> %build
>> aclocal
>> autoconf
>> %configure --enable-elf-shlibs --enable-nls --disable-e2initrd-helper
>> --enable-blkid-devmapper --enable-blkid-selinux --enable-dynamic-e2fsck
>> make %{?_smp_mflags}
>>
> 
> It should be fine if you eliminate the "aclocal" call.  And I've never
> understood why people like to regenerate configure scripts from
> configure.in in the first place....

Well, we patched configure.in too, for other reasons...  that at least
explains the autoconf call.  And I'll plead inheritance on some of this ;)

> In any case, I've just released e2fsprogs 1.40.6.  It contains some of
> obviously correct patches from the Novell and Red Hat packages.  More
> importantly, it includes the "mke2fs -E test_fs" feature which will be
> needed once we push test_fs ext4 patches to mainline, which I plan to
> push to Linus in the next day or two.

Good deal.  I'll push that to Rawhide tomorrow.

Thanks,
-Eric
