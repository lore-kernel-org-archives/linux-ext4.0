From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (Dec. 13 2006)
Date: Wed, 13 Dec 2006 17:08:34 -0700
Message-ID: <20061214000834.GB5937@schatzie.adilger.int>
References: <45809003.5060403@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:36839 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbWLNAIg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Dec 2006 19:08:36 -0500
To: "AVANTIKA R. MATHUR" <mathur@linux.vnet.ibm.com>
Content-Disposition: inline
In-Reply-To: <45809003.5060403@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Dec 13, 2006  15:42 -0800, AVANTIKA R. MATHUR wrote:
> - Change Attribute:   
>  -- Andreas asked the bull team why a new field in the inode is 
> necessary rather than using the i_version field, and also mentioned that 
> all code changes can be in mark_inode_dirty.   
>  -- The ctime cannot be used for the change attribute because if the 
> server clock is incorrect, the ctime can go backwards in time.
>  -- semantics needed: nfsv4 and bull team require 32 bits, clusterfs 
> needs 64 bits.

Minor clarification.  Bull patch for NFSv4 only uses 32 bits, but apparently
the NFSv4 spec calls for 64 bits.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
