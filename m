From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fallocate_zero_range, check if is regular file
Date: Fri, 18 Apr 2014 11:52:51 -0400
Message-ID: <20140418155251.GA16490@thunk.org>
References: <CAGW2f1GoMPwcO3o4Q=As-DkiT2WPN7BiEkq1=RYfX6rnpExipA@mail.gmail.com>
 <CAOiN93=1BBvgUg3Zk9xC1WkBa87UDhR0C_=gsLOM1SSq9BhR0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jon ernst <jonernst07@gmail.com>,
	"linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>
To: Ashish Sangwan <ashishsangwan2@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48387 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaDRPww (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Apr 2014 11:52:52 -0400
Content-Disposition: inline
In-Reply-To: <CAOiN93=1BBvgUg3Zk9xC1WkBa87UDhR0C_=gsLOM1SSq9BhR0Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks, applied with the error code changed to -EINVAL.

		     	       	    - Ted
