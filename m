From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: Release of e2fsprogs 1.43.7
Date: Tue, 17 Oct 2017 20:27:51 -0500
Message-ID: <8ce9cce1-85e6-b7f3-3f09-feeb8d87811b@redhat.com>
References: <20171017164246.atxwp33wategeiba@thunk.org>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762071AbdJRB1w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 17 Oct 2017 21:27:52 -0400
In-Reply-To: <20171017164246.atxwp33wategeiba@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/17/17 11:42 AM, Theodore Ts'o wrote:
> I've released e2fsprogs 1.43.7 in all of the usual places; it's tagged
> in the git trees on git.kernel.org, github, and sourceforge, and
> available for download at:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.7

note, that URL doesn't exist anymore.  no more ftp.

now:

https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.43.7/

> and
> 
> http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.43.7.tar.gz

FWIW, the tarball on kernel.org is a few source files short of a full deck.

It extracts into e2fsprogs-libs-1.43.7/ and does indeed seem to include
only libraries.

-Eric
 
> The release notes for 1.43.7 can be found below.
> 
> E2fsprogs 1.43.7 (October 16, 2017)
> ===================================
> 
> Fix the error handling code in debugfs, fuse2fs and tune2fs so errors
> trying to replay the journal won't accidentally result in a seg fault
> if reopening the file system after the journal replay fails for some
> reason.
> 
> Fix resize2fs to avoid it from either failing or corrupting the file
> system image in certain corner cases when doing an off-line resize.
> 
> Fix many spelling mistakes in various man pages, code comments, and
> program messages.
> 
> Fix e2fsck and debugfs so that maliciously corrupted file systems will
> not cause buffer overflows.  (Addresses Debian Bugs: #873757, #878104)
> 
> Update German translation.  (Addresses Debian Bug: #833514)
> 
> Fixed various Debian Packaging Issues.  (Addresses Debian Bugs:
> #873812, #873813, #876551)
> 
> Programming notes
> -----------------
> 
> Test descritions have been shorted to fit in 80 columns.
> 
> Fix various tests to avoid leaving temp files in /tmp.
> 
