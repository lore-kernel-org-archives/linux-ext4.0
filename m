From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Mixup with name_len & file_type in e2fsprogs
Date: Thu, 7 Mar 2013 19:44:38 -0500
Message-ID: <20130308004438.GA29720@thunk.org>
References: <20130305121856.GA11824@quack.suse.cz>
 <20130305182946.GB26122@thunk.org>
 <20130305184138.GA19601@quack.suse.cz>
 <20130307182444.GA21237@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51889 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626Ab3CHAom (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 19:44:42 -0500
Content-Disposition: inline
In-Reply-To: <20130307182444.GA21237@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 07, 2013 at 07:24:44PM +0100, Jan Kara wrote:
>   I was thinking some more about it. Won't it be cleaner (and not much
> harder) if we always used ext2_dir_entry_2 in e2fsprogs and properly did
> byte swapping of name_len only if FILETYPE feature isn't enabled? I've
> checked and it would mean changing prototypes of like 8 functions in
> ext2fs.h (or better provide new functions with struct ext2_dir_entry_2
> argument) which doesn't seem too bad... This solution seems to be the least
> surprising to the users of libext2fs (esp. if they do some scanning of
> directory blocks themselves or so).

What worries me is potential ABI breackages if we try to redefine
existing interfaces as using ext2_dir_entry_2.  And I'm not convinced
it's worth it to create new versions of the functions that use the new
structure.  This is why I suggested using accessor functions....

	    	    	  	    	  	   - Ted
