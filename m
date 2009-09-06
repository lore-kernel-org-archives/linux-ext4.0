From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH -V2] ext4: Drop mapped buffer_head check during
	page_mkwrite
Date: Sat, 5 Sep 2009 23:49:51 -0400
Message-ID: <20090906034951.GG3055@mit.edu>
References: <1251264196-31382-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090829022656.GK16732@mit.edu> <20090831063006.GA7711@skywalker.linux.vnet.ibm.com> <20090831122448.GG20822@mit.edu> <20090831123313.GA21973@skywalker.linux.vnet.ibm.com> <20090831125025.GI20822@mit.edu> <20090831170601.GA26003@skywalker.linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48099 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZIFDt5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Sep 2009 23:49:57 -0400
Content-Disposition: inline
In-Reply-To: <20090831170601.GA26003@skywalker.linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

OK, I've added this patch to the ext4 patch queue.

    	       	    	     	 - Ted
