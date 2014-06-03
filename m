From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: fix bug in ext4_mb_normalize_request()
Date: Tue, 3 Jun 2014 16:36:39 -0400
Message-ID: <20140603203639.GB25483@thunk.org>
References: <1393855228-13592-1-git-send-email-mlombard@redhat.com>
 <1393855228-13592-3-git-send-email-mlombard@redhat.com>
 <20140306154407.GA28226@thunk.org>
 <20140306165416.GA2182@dhcp-27-189.brq.redhat.com>
 <alpine.LFD.2.00.1403061842240.2249@localhost.localdomain>
 <20140526165010.GN22284@thunk.org>
 <alpine.LFD.2.00.1406032040210.2095@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maurizio Lombardi <mlombard@redhat.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1406032040210.2095@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 03, 2014 at 08:43:40PM +0200, Luk=C3=A1=C5=A1 Czerner wrote=
:
>=20
> I think that leaving the alignment of the start offset for the small
> files/allocation is not good idea. We might end up with suboptimal
> file layout for smaller files. While this is not a big deal for
> bigger files, with smaller ones it might cause some troubles.

I thought we were only aligning the start offset for files > 2MB?

> Also I started looking into normalize_request and hopefully I'll
> have a patch soon. Ted, do you have any suggestion for a test to
> make sure that I do not make things worse ? You mentioned something
> simple on LSF, but I do not remember what it was.

The two mechanisms which we have currently are:

1) e2freefrag to measure free space fragmentation

2) e2fsck -fE fragcheck /dev/sdXX

The latter will give you a reports such as this:

142618(f): expecting 950605 actual extent phys 950800 log 89 len 26
142618(f): expecting 950826 actual extent phys 950550 log 282 len 10

Which would correspond to the following:

debugfs:  stat <142618>
Inode: 142618   Type: regular    Mode:  0666   Flags: 0x80000
Generation: 2697220261    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 1194112
=46ile ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 360
=46ragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x53495656:aa328a78 -- Sat Apr 12 11:05:58 2014
 atime: 0x53495643:c20a0ea4 -- Sat Apr 12 11:05:39 2014
 mtime: 0x53495653:43ad6c78 -- Sat Apr 12 11:05:55 2014
crtime: 0x53495641:1332f128 -- Sat Apr 12 11:05:37 2014
Size of extra inode fields: 28
EXTENTS:
(68-76):950596-950604, (89-114):950800-950825, (282-291):950550-950559

This is admittedly imperfect.  First of all, it gives false positives
when the file has holes (as in the above case).  And even if it didn't
what we should do is to print the previous extent before the
contiunity, since what's interesting is how big was the previous
extent before we had a discontinuity, and because the length of the
current extent isn't all that interesting in the case of last extent
(the "tail") of the file.

Hmm... if I have time I might look into patching e2fsck so that e2fsck
-E fragcheck is more useful.

What's also missing is some way of taking all of this fine-grained
information is turning it into one to three figures of merit that
could be used to compare different tweaks to the block allocation
algorithm.

Cheers,

					- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
