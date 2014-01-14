From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: high write latency bug in ext3 / jbd in 3.4
Date: Mon, 13 Jan 2014 19:01:50 -0600
Message-ID: <52D48C7E.40509@redhat.com>
References: <20140113201320.GD1214@kvack.org> <99F82313-71DA-43E6-A071-05507183D481@dilger.ca> <20140113211610.GE1214@kvack.org> <20140113225219.GD11207@thunk.org> <098224F1-62F8-4AEC-835B-45201F97243C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Benjamin LaHaise <bcrl@kvack.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbaANBB6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 20:01:58 -0500
In-Reply-To: <098224F1-62F8-4AEC-835B-45201F97243C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/13/14, 6:55 PM, Andreas Dilger wrote:
> On Jan 13, 2014, at 3:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Jan 13, 2014 at 04:16:10PM -0500, Benjamin LaHaise wrote:
>>> I had hoped to use ext4, but the recommended fsck after changing the 
>>> various feature bits is a non-starter during our upgrade process (a 22 
>>> minute outage isn't acceptable).
>>
>> You can move to ext4 without necessarily using those features which
>> require an fsck after the upgrade process.  That's hwo we handled the
>> upgrade to ext4 at Google.  New disks were formatted using ext4, but
>> for legacy file systems, we enabled extents feature (maybe one or two
>> other ones, but that was the main one) and then remounted those file
>> systems using ext4.
> 
> We also did this for upgraded Lustre ext3 filesystems in the past
> (just enabling the extents feature) without any problems.  So long
> as you don't need things like fallocate() (which presumably you don't
> since that doesn't work for ext3) then the application can't tell the
> difference between new extent-mapped and old block-mapped files.
> 
> This only affects new files, so old files are not changed.

Which was my point about ending up with a mishmash.  Maybe it's
ok, depends on your usecase.

But you wind up with different files on the same fs having different
capabilities depending on whether they are extent format or not.
(for example you can't do preallocation on the old format files,
they have different maximum offset limits, different direct IO
behavior...)

Just something to be aware of.

- -Eric

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS1Ix+AAoJECCuFpLhPd7gLxMP/1kGrivmUostFaw3w2ldQaXj
vkP+lfWE3lYPLDTuJbkVdLZlruOxY01KwG+DoYVyhDj9ykbVRJdyrQaTY38o6MNv
/xgHQdESlw0MwYifT2mppphZfMEcNJYnqImdeQ34POzhdmclnKil25pif4a+eR2u
VXgcK6vAD+YTFzjJ0/G3WknIOjCkD6OX1uljXkUMAEZFOuEIgp96GEaNT1Zh6sGy
NoRM35n6WnOvfFBhZVg1CEvwSgg2ETC89tLjomZMnnjOaKPaEYwG84aD5DVcDPB/
9mXtD1bOYcdXrappVefCC5BI3x7Nft9POuw3o9xan4f1+vSSusBhwNJD7FWt6N+1
faQAbD5tXaG27g7/sFJpc/Yn8coWbY4GDsB6/carZP+O7N6TK45gkH1GLfde5m8A
1onZEFn2jEQjmRmGO6wkpQGJOLlEt347joUiEvYeV2tncu+TPDFJEY5T8r6A30pa
+iTmzc0NiP9/A9087NEd+15UtLS62VUkhQxwJDWpnZZ77C6ZiqwXnyHlzSi6BGOh
f8BpVncVAS04nih7BGquri3JsL7o3IcvtlATj/wrZO3adeoYQWiJHxBFrrsi/cUI
WjhhWXR1GIZ//W6/wTcEe3wNUxY3RP8X5Yb4P1FlRYzt8jMVvSpFtzh73C9Fhc0H
WlJoDj0OA1QI5Mrjliz0
=KYq3
-----END PGP SIGNATURE-----
