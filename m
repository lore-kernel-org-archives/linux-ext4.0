From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 12/23] ext4: convert s_{dirty,free}blocks_counter to s_{dirty,free}clusters_counter
Date: Wed, 6 Jul 2011 16:59:59 -0600
Message-ID: <05C9E747-3956-4E45-8973-C1574CE88575@dilger.ca>
References: <1309970166-11770-1-git-send-email-tytso@mit.edu> <1309970166-11770-13-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57426 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1GFXAA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 19:00:00 -0400
In-Reply-To: <1309970166-11770-13-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-07-06, at 10:35 AM, Theodore Ts'o wrote:
> Convert the percpu counters s_dirtyblocks_counter and
> s_freeblocks_counter in struct ext4_super_info to be
> s_dirtyblocks_counter and s_freeclusters_counter.

Commit comment is incorrect.  Should be "s_dirtyclusters_counter"
at the second usage.

Cheers, Andreas





