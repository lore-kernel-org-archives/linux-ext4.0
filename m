From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC][PATCH 0/8 v2] ext4: extent status tree (step 1)
Date: Fri, 21 Sep 2012 20:02:17 -0400
Message-ID: <20120922000217.GB27207@thunk.org>
References: <1345615545-26133-1-git-send-email-wenqing.lz@taobao.com>
 <20120920144126.GA22334@thunk.org>
 <CAGBYx2bSCBzLAwXQOkgVOrOAxG_LJ2WzF_Bk6Oh9V6q1vuky0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51980 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744Ab2IVACZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Sep 2012 20:02:25 -0400
Content-Disposition: inline
In-Reply-To: <CAGBYx2bSCBzLAwXQOkgVOrOAxG_LJ2WzF_Bk6Oh9V6q1vuky0w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 21, 2012 at 11:19:54AM +0800, Yongqiang Yang wrote:
> Hi  Ted,
> 
> I notices you cares Signed-off line, so I just throw a message.
> 
> I noticed you changed all Signed-off line of patches, some patches are
> written by me initially and is modified by Allison and Zheng. So I
> think Signed-off line should be me, Allison and Zheng.  Do I
> misunderstand the rules?

Thanks, I didn't realize that you and Allison had written parts of the
patches.  Yes, in that case it should be "Signed-off-by".  I've made
this change to my tree.  (And this is why I don't cast commits into
stone for a few days before I advance the master branch pointer.)

      	    	     	      	      	  	 - Ted
