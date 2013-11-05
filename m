From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] rbtree: fix postorder iteration when the rb_node
 is not the first element in an entry
Date: Tue, 05 Nov 2013 02:05:44 -0800
Message-ID: <5278C2F8.3050805@linux.vnet.ibm.com>
References: <52784ADF.1040104@linux.vnet.ibm.com> <1383615602-1784-1-git-send-email-cody@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	LKML <linux-kernel@vger.kernel.org>,
	EXT4 <linux-ext4@vger.kernel.org>,
	Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383615602-1784-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/04/2013 05:40 PM, Cody P Schafer wrote:
> Provide a new helper called rb_next_postorder_entry() to perform NULL
> checks and container_of() coversions and use it in
> rbtree_for_each_entry_safe() to fix oopses that occur when rb_node is
> not the first element in the entry.

On second thought, it appears I was a bit to hasty with this, and this patch actually breaks things.

On 11/04/2013 04:45 PM, Jan Kara wrote:> On Mon 04-11-13 15:26:38, Jan Kara wrote:
>> On Fri 01-11-13 15:38:50, Cody P Schafer wrote:
>>> Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
>>> of opencoding an alternate postorder iteration that modifies the tree
>>    Thanks. I've merged the patch into my tree.
>    Hum, except that the kernel oopses with this patch. And I think the
> problem is in rbtree_postorder_for_each_entry_safe(). How are those tests
> for NULL supposed to work? For example if the tree is empty, 'pos' will be
> NULL and you'll call rb_next_postorder(&NULL->field) which is pretty much
> guaranteed to oops if 'field' doesn't have offset 0 in the structure...

No, it shouldn't oops because pos won't be NULL, &pos->field will be.

pos is only assigned via an rb_entry(rb_first_postorder()) or rb_entry(rb_next_postorder()). rb_next_postorder() and rb_first_postorder() can return NULL. That NULL then is munged by rb_entry to be (NULL - offset_of_field). Causing (&pos->field == NULL == (pos + offset_of_field)).

That is, unless I've screwed something up (very possible, as this overly hurried patchset shows).

I expect it's more likely that my adaptation of this to ext3's usage is buggy. Could you tell me what you did to cause the oops? And/Or post it?
