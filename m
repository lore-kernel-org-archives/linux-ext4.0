From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] provide missing mode for open-create in check_mntent_file
Date: Fri, 17 Aug 2007 11:29:21 -0600
Message-ID: <20070817172921.GF5420@schatzie.adilger.int>
References: <46C4D18E.3080509@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([74.0.229.162]:60231 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbXHQR3O (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Aug 2007 13:29:14 -0400
Content-Disposition: inline
In-Reply-To: <46C4D18E.3080509@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Aug 16, 2007  17:37 -0500, Eric Sandeen wrote:
> F8 is catching opens with O_CREAT flags and no mode now, and refusing
> to build them... 

Yay, we had bugs-o-plenty in Lustre because of this being done in apps.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
