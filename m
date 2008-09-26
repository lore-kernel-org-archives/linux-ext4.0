From: "=?EUC-KR?B?yKu9xSBzaGluIGhvbmc=?=" <hongshin@gmail.com>
Subject: a question for i_inode's i_size in ext2
Date: Fri, 26 Sep 2008 13:53:24 +0900
Message-ID: <2014bcab0809252153v65ebd234le5de8ae27181ae1e@mail.gmail.com>
References: <2014bcab0809190021qbca7bect601c891c2db197cf@mail.gmail.com>
	 <20080920032522.GB9633@atrey.karlin.mff.cuni.cz>
	 <20080920063502.GB12762@mit.edu>
	 <2014bcab0809252152i6fef9babx242e821c4f0d5a7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:24264 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYIZExZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 00:53:25 -0400
Received: by rv-out-0506.google.com with SMTP id k40so807490rvb.1
        for <linux-ext4@vger.kernel.org>; Thu, 25 Sep 2008 21:53:24 -0700 (PDT)
In-Reply-To: <2014bcab0809252152i6fef9babx242e821c4f0d5a7b@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Thank you for the answering.

  In ext2, it seems to me that inode's i_size field can be accessed
without holding i_mutex
  nor thorugh i_size_read function.

  For example, in ext2_update_inode() can be invoked without holding i_mutex.
  However, it freely access i_size field.

  Are these accesses can race with each others?


  Sincerely
  Shin Hong
