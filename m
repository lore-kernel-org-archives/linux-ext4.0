From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: next-20141204 crashing on ext4_fill_super()
Date: Sat, 6 Dec 2014 17:16:21 -0500
Message-ID: <20141206221621.GB27484@thunk.org>
References: <2144577.XOl86X9GoH@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2144577.XOl86X9GoH@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Please revert fdfe07398761 and that should the crashes; this will be
fixed in the next linux-next release.  My apologies for the inconvenience.

      	     	  	     	       	  	    - Ted
