From: Alex Tomas <alex@clusterfs.com>
Subject: Re: Updated patches for journal checksums.
Date: Tue, 19 Jun 2007 13:10:53 +0400
Message-ID: <46779D9D.2090109@clusterfs.com>
References: <1182239437.3784.11.camel@dhcp7.linsyssoft.com> <46778DBE.3090801@clusterfs.com> <1182240928.3784.18.camel@dhcp7.linsyssoft.com> <20070619085141.GR5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Girish Shilamkar <girish@clusterfs.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chehov.net ([80.71.245.247]:59908 "EHLO mail.rialcom.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755407AbXFSJLO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Jun 2007 05:11:14 -0400
In-Reply-To: <20070619085141.GR5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> I _think_ Alex is asking "what happens if during a transaction undergoing
> checkpoint of blocks to filesystem (not the last one in the journal) is
> interrupted by a crash and upon restart the partially-checkpointed
> transaction is found to have a checksum error?"

yup, thanks for clarification.

>>> what do we do if transaction in the journal is found with wrong
>>> checksum? leave partial transaction in-place?
>> The sanity of the transaction is checked in PASS_SCAN. And if checksum
>> is found to be incorrect for nth transaction then last transaction which
>> is written to disk is (n - 1).
> 
> The recovery.c code (AFAIK) does not do replay for any transaction that
> does not have a valid checksum, or transactions beyond that.  If the
> bad transaction had already started chekpoint (i.e. isn't the last
> committed transaction) then the journal _should_ return an error up to
> the filesystem, so it can call ext4_error() at startup.  For e2fsck
> (which normally does journal replay & recovery) it can do a full
> filesystem check at this point.

hmm. it actually can be last transaction (following no activity?)

thanks, Alex
