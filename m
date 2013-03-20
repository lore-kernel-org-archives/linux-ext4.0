From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: fix ext4_evict_inode() racing against workqueue
 processing code
Date: Wed, 20 Mar 2013 09:14:42 -0500
Message-ID: <5149C452.3070206@redhat.com>
References: <1363742959-12815-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3CTOP3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 20 Mar 2013 10:15:29 -0400
In-Reply-To: <1363742959-12815-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/19/13 8:29 PM, Theodore Ts'o wrote:
> Commit 84c17543ab56 (ext4: move work from io_end to inode) triggered a
> regression when running xfstest #270 when the file system is mounted
> with dioread_nolock.


As an aside, is there any reason to have "dioread_nolock" as an option
at this point?  If it works now, would you ever *not* want it?

(granted it doesn't work with some journaling options etc, but that
behavior could be automatic, w/o the need for special mount options).

-Eric
