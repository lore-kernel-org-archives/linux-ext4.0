From: Alex Tomas <alex@clusterfs.com>
Subject: Re: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Tue, 02 Jan 2007 12:25:21 +0300
Message-ID: <m364bpn5ku.fsf@bzzz.home.net>
References: <20070102090909.GA20503@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fe02.tochka.ru ([62.5.255.22]:43650 "EHLO umail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932413AbXABJZc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jan 2007 04:25:32 -0500
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
In-Reply-To: <20070102090909.GA20503@amitarora.in.ibm.com> (Amit K. Arora's
	message of "Tue\, 2 Jan 2007 14\:39\:09 +0530")
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> Amit K Arora (AKA) writes:

 AKA> The ext4_ext_get_blocks() and ext4_ext_insert_extent() routines do not
 AKA> check for extent overlap, when a new extent needs to be inserted in an
 AKA> inode. An overlap is possible when the new extent being inserted has
 AKA> ee_block that is not part of any of the existing extents, but the
 AKA> tail/center portion of this new extent _is_. This is possible only when
 AKA> we are writing/preallocating blocks across a hole.

not sure I understand ... you shouldn't insert an extent that overlap
any existing extent. when you write block(s), you first check is
it already allocated and insert new extent only if it's not. for
preallocated block(s), you should adapt existing extent(s) so that
they don't overlap new extent you're inserting. am I missing something?
also, I think that modification of existing extent(s) (not merging)
isn't safe.

thanks, Alex
