From: Girish Shilamkar <girish@clusterfs.com>
Subject: Re: Updated patches for journal checksums.
Date: Tue, 19 Jun 2007 13:45:28 +0530
Message-ID: <1182240928.3784.18.camel@dhcp7.linsyssoft.com>
References: <1182239437.3784.11.camel@dhcp7.linsyssoft.com>
	 <46778DBE.3090801@clusterfs.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@clusterfs.com>
To: Alex Tomas <alex@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:50951 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXFSIP3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Jun 2007 04:15:29 -0400
In-Reply-To: <46778DBE.3090801@clusterfs.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 2007-06-19 at 12:03 +0400, Alex Tomas wrote:
> say, at mount time we fund transaction logged. this means part of it can be
> on a disk. 
I am not sure I understand this completely. Still I hope the following
answers your question.

> what do we do if transaction in the journal is found with wrong
> checksum? leave partial transaction in-place?
> 
The sanity of the transaction is checked in PASS_SCAN. And if checksum
is found to be incorrect for nth transaction then last transaction which
is written to disk is (n - 1).



Regards,
Girish
