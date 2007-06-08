From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] JBD2: Change debug file path
Date: Fri, 8 Jun 2007 01:08:12 -0600
Message-ID: <20070608070812.GE5181@schatzie.adilger.int>
References: <20070607234537.56537f85@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:57695 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbXFHHIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Jun 2007 03:08:14 -0400
Content-Disposition: inline
In-Reply-To: <20070607234537.56537f85@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 07, 2007  23:45 -0500, Jose R. Santos wrote:
> The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
> create_proc_entry() does not do lookups on file names with more that one
> directory deep.  This causes the entry creation to fail and hence, no proc
> file is created.  This patch moves the file to /proc/jbd2-degug.
> 
> The file could be move to /proc/fs/jbd2/jbd2-debug, but it would require
> some minor alterations to the jbd-stats patch.

I don't think we really want to be adding top-level files in /proc.
What about using the "debugfs" filesystem (not to be confused with
the e2fsprogs 'debugfs' command)?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
