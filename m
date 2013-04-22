From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] e2image: require that -a option is used only with
 raw or QCOW2 image
Date: Sun, 21 Apr 2013 23:23:42 -0400
Message-ID: <20130422032342.GD12221@thunk.org>
References: <1363425205-10970-1-git-send-email-tracek@redhat.com>
 <1363425205-10970-3-git-send-email-tracek@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Tomas Racek <tracek@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43357 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3DVDXo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Apr 2013 23:23:44 -0400
Content-Disposition: inline
In-Reply-To: <1363425205-10970-3-git-send-email-tracek@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Mar 16, 2013 at 10:13:25AM +0100, Tomas Racek wrote:
> All data cannot be included in normal image file so e2image should exit
> in this case.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Thanks, applied with the whitespace nit which Eric pointed out fixed.

		     	 	    	- Ted
