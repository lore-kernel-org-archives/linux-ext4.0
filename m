From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: group info caches set to SLAB_MEM_SPREAD flags.
Date: Sat, 19 Nov 2011 22:35:34 -0500
Message-ID: <20111120033534.GH4130@thunk.org>
References: <1321742924-3189-1-git-send-email-linkinjeon@gmail.com>
 <alpine.DEB.2.00.1111191524200.5986@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	Amit Sahrawat <amit.sahrawat83@gmail.com>
To: David Rientjes <rientjes@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111191524200.5986@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Nov 19, 2011 at 03:29:34PM -0800, David Rientjes wrote:
> If there is convincing data that suggests it's helpful on your hardware, 
> then it would make a good case to merge your patch so users don't need to 
> set their own mempolicies that do this.  They'll just need to mount 
> cpusets and enable cpuset.memory_spread_slab.

>From Namjae and Amit have stated, they don't have access to any NUMA
hardware.  If I had to guess they are students or people who are
trying to start a Linux development team at some company or research
institute, and have decided to start by sending cleanup patches.

	       	    	       	     	- Ted
