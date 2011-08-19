From: Ivan Shmakov <ivan@gray.siamics.net>
Subject: Re: a (documented) way to get the Ext2+ filesystem size?
Date: Fri, 19 Aug 2011 11:34:58 +0700
Message-ID: <86obzmuih9.fsf@gray.siamics.net>
References: <86aab94mfg.fsf@gray.siamics.net>
	<20110817183101.GC6901@thunk.org> <86mxf7yirb.fsf@gray.siamics.net>
	<20110817220953.GD6901@thunk.org> <86ei0jxtt9.fsf@gray.siamics.net>
	<20110818210313.GA4602@thunk.org>
Reply-To: Ivan Shmakov <oneingray@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:52420 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab1HSEfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Aug 2011 00:35:13 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gcfe-linux-ext4@m.gmane.org>)
	id 1QuGnY-0006tx-1k
	for linux-ext4@vger.kernel.org; Fri, 19 Aug 2011 06:35:12 +0200
Received: from gray.am-1.org ([188.120.231.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 06:35:12 +0200
Received: from oneingray by gray.am-1.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Fri, 19 Aug 2011 06:35:12 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> Ted Ts'o <tytso@mit.edu> writes:
>>>>> On Thu, Aug 18, 2011 at 10:49:38AM +0700, Ivan Shmakov wrote:

[=E2=80=A6]

 >> I don't seem to understand.  I've scanned through the
 >> (libext2fs.info) Function Index section (as per the Debian's
 >> e2fslibs-dev package, 1.41.12-2), and I see no mention of a functio=
n
 >> that I can use for that.

 > Sorry, the documentation is not necessarily complete; my apologies.

	Perhaps I could take a look at that later.

 >> Thus, I've ended up writing my own one, which takes an ext2_filsys
 >> handle, and references, via its =E2=80=98super=E2=80=99 member, the=
 =E2=80=98s_blocks_count=E2=80=99
 >> and =E2=80=98s_blocks_count_hi=E2=80=99 members of the superblock s=
tructure.

 > The function to do this is in the 1.42 dev branch which is in Debian
 > unstable, and it's called ext2fs_block_count().

	ACK.  Thanks!

	As I don't plan to introduce a dependency on anything above
	Debian stable, I'll probably add a configure check for that
	function, and if fails, will use either my own code, or the
	copied from the newer e2fsprogs sources.

 >> However, I was concerned that I don't seem to find the documentatio=
n
 >> for these structures' contents anywhere.  (Sans the source, of
 >> course), and wondered, if the interface I use is at least stable?

 > I make a very strong effort to ensure that interfaces which are
 > exposed via the shared library are stable.  If you're not sure,
 > please feel free to ask on the ext4 list.

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
