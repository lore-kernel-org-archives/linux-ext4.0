From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: ext2fs_test_block_bitmap (): Unknown code ext2 47 #0, etc.
Date: Wed, 24 Aug 2011 00:26:37 +0700
Message-ID: <86bovgqbsi.fsf@gray.siamics.net>
References: <86ei0p8ve2.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151125470.3695@dhcp-27-109.brq.redhat.com>
	<86zkjb3p7f.fsf@gray.siamics.net>
	<alpine.LFD.2.00.1108151759040.3695@dhcp-27-109.brq.redhat.com>
	<86ei0k1tbc.fsf@gray.siamics.net> <867h6awuq5.fsf_-_@gray.siamics.net>
	<20110822043103.GB3671@thunk.org>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:38093 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab1HWR04 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Aug 2011 13:26:56 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QvukZ-0003rj-85
	for linux-ext4@vger.kernel.org; Tue, 23 Aug 2011 19:26:55 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2011 19:26:55 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Tue, 23 Aug 2011 19:26:55 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Ted Ts'o <tytso@mit.edu> writes:
>>>>> On Thu, Aug 18, 2011 at 11:27:30PM +0700, Ivan Shmakov wrote:

[=E2=80=A6]

 >> However, I'm getting the following message on stderr upon a call
 >> (only the first one?) to ext2fs_test_block_bitmap ():

 >> --cut--
 >> Unknown code ext2 47 #0 for block bitmap for /dev/stdin
 >> --cut--

 > You're not getting a human-readable error message because you need t=
o
 > add the following at the beginning of your program:

 > add_error_table(&et_ext2_error_table);

	Thanks for the suggestion!

[=E2=80=A6]

 > The 47th error message in the ext2 error table, which would have bee=
n
 > printed if you had called add_error_table(), is:

 > Illegal block number passed to ext2fs_test_block_bitmap

 > This means you've passed in a block number which is out-of-range for
 > the block bitmap.

	Do I understand it correctly that the block #0 isn't covered by
	any bitmap?  (I guess it's reserved for bootloaders, etc.)

 >> Also, do I understand it correctly that I need to call
 >> ext2fs_read_block_bitmap () before accessing the block_map member o=
f
 >> the ext2_filsys structure?

 > Yes, or if you are going to need to read in both the block and inode
 > bitmaps, you can use ext2fs_read_bitmaps(), which will be more
 > optimal for reading in the block bitmaps.

	ACK.  Thanks.

--=20
=46SF associate member #7257	Coming soon: Software Freedom Day
http://mail.sf-day.org/lists/listinfo/ planning-ru (ru), sfd-discuss (e=
n)

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
