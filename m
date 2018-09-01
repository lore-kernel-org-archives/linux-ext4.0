From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: avoid arithemetic overflow that can trigger a BUG
Date: Fri, 31 Aug 2018 22:50:03 -0400
Message-ID: <20180901025003.GB27277@thunk.org>
References: <20180831174126.13071-1-tytso@mit.edu>
 <27af5487-9579-0950-94b5-0292b80e37c7@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        stable@vger.kernel.org
To: Jiri Slaby <jslaby@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <27af5487-9579-0950-94b5-0292b80e37c7@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 31, 2018 at 09:31:36PM +0200, Jiri Slaby wrote:
> 
> Can't this be just
> 
> map.m_len = min_t(unsigned long, last_block - first_block + 1, UINT_MAX)?

Yes, good point, thanks.

					- Ted
