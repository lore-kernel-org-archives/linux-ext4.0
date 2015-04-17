From: Jan Kara <jack@suse.cz>
Subject: Use of resize2fs for enabling 64-bit inodes
Date: Fri, 17 Apr 2015 18:18:09 +0200
Message-ID: <20150417161809.GA27500@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbbDQQSL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Apr 2015 12:18:11 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  I've noticed that you've implemented enabling 64-bit mode of a filesystem
in resize2fs. That is quite logical from the implementation point of view
however IMHO it doesn't make too much sense from user point of view.  I'd
rather expect that functionality to be in tune2fs. So shouldn't we rather
abstract the code into a separate library that would be linked to both
resize2fs and tune2fs? Alternatively we could just make tune2fs call
resize2fs with appropriate options.

I'm asking because I'm now looking into implementing increasing number of
reserved inodes. For that we may need to move some inodes and it would be
natural to use code from resize2fs for that. But adding that as an option
to resize2fs is just unintuitive from user point of view so I'd like to
have some concensus on how we do this... Darrick, Ted, any opinion?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
