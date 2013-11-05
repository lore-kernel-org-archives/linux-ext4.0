From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/8] fs/ext3: use rbtree postorder iteration helper instead
 of opencoding
Date: Mon, 04 Nov 2013 17:33:19 -0800
Message-ID: <52784ADF.1040104@linux.vnet.ibm.com>
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com> <1383345566-25087-6-git-send-email-cody@linux.vnet.ibm.com> <20131104142638.GD8566@quack.suse.cz> <20131105004559.GB24531@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46647 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab3KEBdX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Nov 2013 20:33:23 -0500
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <cody@linux.vnet.ibm.com>;
	Mon, 4 Nov 2013 20:33:22 -0500
In-Reply-To: <20131105004559.GB24531@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/04/2013 04:45 PM, Jan Kara wrote:
> On Mon 04-11-13 15:26:38, Jan Kara wrote:
>> On Fri 01-11-13 15:38:50, Cody P Schafer wrote:
>>> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
>>> of opencoding an alternate postorder iteration that modifies the tree
>>    Thanks. I've merged the patch into my tree.
>    Hum, except that the kernel oopses with this patch. And I think the
> problem is in rbtree_postorder_for_each_entry_safe(). How are those tests
> for NULL supposed to work? For example if the tree is empty, 'pos' will be
> NULL and you'll call rb_next_postorder(&NULL->field) which is pretty much
> guaranteed to oops if 'field' doesn't have offset 0 in the structure...
> 	

You're absolutely right, those NULL checks are wrong when the rb_node 
isn't the first element. Fix incoming shortly.

