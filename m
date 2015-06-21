From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH v2] debugfs/set_fields: fix several errors and add assertions
Date: Sun, 21 Jun 2015 15:15:16 -0600
Message-ID: <9E0F67A4-4D7E-4954-A64A-CB4B641FEAF8@dilger.ca>
References: <20150225094728.14523.52763.stgit@buzz> <20150620020158.GD29480@thunk.org> <CALYGNiPG5c_QVVKPgc6gFM59Styx2Lxn97SMPB=38JWYzgp0NQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>, Li Xi <lixi@ddn.com>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35674 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbFUVPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 21 Jun 2015 17:15:48 -0400
Received: by pdbci14 with SMTP id ci14so66371064pdb.2
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2015 14:15:47 -0700 (PDT)
In-Reply-To: <CALYGNiPG5c_QVVKPgc6gFM59Styx2Lxn97SMPB=38JWYzgp0NQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Jun 20, 2015, at 6:30 AM, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> 
> On Sat, Jun 20, 2015 at 5:01 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Wed, Feb 25, 2015 at 12:47:28PM +0300, Konstantin Khlebnikov wrote:
>>> Fix copy-n-paste errors:
>>> * remove duplicate "lastcheck" and "min_extra_isize"
>>> * fix pointer for "first_error_line" and "last_error_line"
>>> * remove superblock field "inodes_count" from inode fields
>>> * add null-termination for mmp_fields
>>> 
>>> Add assertions for catching such errors in the future.
>>> Mark true aliases with flag "FLAG_ALIAS" and suppress assert for them.
>>> 
>>> v2: check tables in unit test "debugfs/tst_set_fields"
>>> 
>>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>> 
>> Applied, thanks.   Apologies for the delay.
> 
> No problem. Thanks.
> 
> I have a somehow related question: do you interested in project quota in ext4?
> 
> It seems I could revisit that task once again.
> This time I could make it completely compatible with XFS. Looks like
> last time all objections were about my attempt of making overall
> behaviour more useful.

There are a recent set of ext4 project quota patches from Li Xi posted
to the list that are already compatible with XFS.  All that is needed
to get them landed is some testing with xfstests to ensure they really
work with the XFS utilities.

Rather than having two competing sets of project quota patches for ext4
it would be better to get this first set of patches landed, and then if
you want to enhance their functionality it can be done on top of those
patches.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
