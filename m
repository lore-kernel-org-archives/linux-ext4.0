From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/10] Fs: ext4: namei: fixed file of checkpatch/pl
 warnings and errors
Date: Sun, 26 Sep 2010 14:23:38 -0400
Message-ID: <20100926182338.GM19690@thunk.org>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
 <1285439521-2557-10-git-send-email-tdent48227@gmail.com>
 <m3pqw16mfh.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tracey Dent <tdent48227@gmail.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:33624 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177Ab0IZSXm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Sep 2010 14:23:42 -0400
Content-Disposition: inline
In-Reply-To: <m3pqw16mfh.fsf@intrepid.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 26, 2010 at 08:36:34AM +0200, Krzysztof Halasa wrote:
> 
> BTW I wouldn't trust checkpatch so blindly. Also keep in mind checkpatch
> is only a tool and that maintainers have full authority to ignore the
> problems (or "problems") it spews.

I'm beginning to think we need to have an entry in the kernel newbie's
FAQ warning people that the output of various scripts such as
checkpatch and get_maintainer are not authoratative, and are
hueristics intended to be supplemented by human intelligence.

	   	       	  	       	  	- TEd
