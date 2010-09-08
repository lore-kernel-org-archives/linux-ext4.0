From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 5/5] Use sb_issue_discard in ext4_ext_zeroout
Date: Wed, 8 Sep 2010 15:21:52 -0600
Message-ID: <30E21BBC-85C1-433D-8785-EB9A12ADD662@dilger.ca>
References: <1283965160-31597-1-git-send-email-lczerner@redhat.com> <1283965160-31597-6-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, rwheeler@redhat.com,
	sandeen@redhat.com, tytso@mit.edu
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25394 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab0IHVVx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Sep 2010 17:21:53 -0400
In-Reply-To: <1283965160-31597-6-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-08, at 10:59, Lukas Czerner wrote:
> Change ext4_ext4_zeroout to use sb_issue_discard instead of its
> own approach to zero out extents.

typo - should be ext4_ext_zeroout().


Cheers, Andreas





