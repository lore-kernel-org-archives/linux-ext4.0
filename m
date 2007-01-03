From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Wed, 03 Jan 2007 12:44:14 +0300
Message-ID: <m3irfobg29.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
	<m364bpn5ku.fsf@bzzz.home.net>
	<20070102094727.GA5932@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Tomas <alex@clusterfs.com>, linux-ext4@vger.kernel.org,
	suparna@in.ibm.com, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:64660 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1749667AbXACJos (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 3 Jan 2007 04:44:48 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070102094727.GA5932@amitarora.in.ibm.com> (Amit K. Arora's
	message of "Tue\, 2 Jan 2007 15\:17\:27 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Amit K Arora (AKA) writes:

 AKA> On Tue, Jan 02, 2007 at 12:25:21PM +0300, Alex Tomas (AT) wrote:
 >> >>>>> Amit K Arora (AKA) writes:
 >> 
 AKA> The ext4_ext_get_blocks() and ext4_ext_insert_extent() routines do not
 AKA> check for extent overlap, when a new extent needs to be inserted in an
 AKA> inode. An overlap is possible when the new extent being inserted has
 AKA> ee_block that is not part of any of the existing extents, but the
 AKA> tail/center portion of this new extent _is_. This is possible only when
 AKA> we are writing/preallocating blocks across a hole.
 >> 
 AT> not sure I understand ... you shouldn't insert an extent that overlap
 AT> any existing extent. when you write block(s), you first check is
 AT> it already allocated and insert new extent only if it's not.

 AKA> You are right. That is what this patch does.
 AKA> The current ext4 code is inserting an overlapped extent in a particular
 AKA> scenario (explained above). The suggested patch fixes this by having a
 AKA> check in get_blocks() for _not_ inserting an extent that may overlap
 AKA> with an existing one.

I think that stuff that converts uninitialized blocks
to initialized ones should be a separate codepath and
shouldn't be done in the insert path. and an insert
(basic tree manipulation) should BUG_ON() one tries
to add extent with a block which is already covered
by the tree.

IMHO, get_blocks() should look like:

  path = find_path()
  if (found extent covers request block(s)) {
    if (extent is uninitialized) {
      convert();
    }
  }

where
   function convert()
  {
    /* adopt existing extent so that it
     * doesn't cover requested blocks */

    /* insert head or tail of existing
     * extent, if necessary */

    /* insert new extent of initialized blocks */
  }

thanks, Alex
