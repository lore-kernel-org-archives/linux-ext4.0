From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH RESEND] Add extent conversion support to chattr
Date: Thu, 28 May 2009 09:10:50 -0400
Message-ID: <20090528131050.GM26625@mit.edu>
References: <1231223834-2785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55403 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443AbZE1NLI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 May 2009 09:11:08 -0400
Content-Disposition: inline
In-Reply-To: <1231223834-2785-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 06, 2009 at 12:07:14PM +0530, Aneesh Kumar K.V wrote:
> This patch adds new option, +e to chattr. The +e option
> is used to convert the ext3 format (non extent) file
> to ext4 (extent) format. This can be used to migrate
> the ext3 file system to ext4 file system.

Thanks, applied.

					- Ted
