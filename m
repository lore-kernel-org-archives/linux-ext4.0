From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3 v2] ext4: Rewrite punch hole to use
 ext4_ext_remove_space()
Date: Wed, 21 Mar 2012 20:48:05 -0400
Message-ID: <20120322004805.GA11157@thunk.org>
References: <1332181175-10503-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43625 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030526Ab2CVAsJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 20:48:09 -0400
Content-Disposition: inline
In-Reply-To: <1332181175-10503-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've updated my tree to use your new version of these patches.

     	     	     	    	 - Ted
