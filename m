From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fixed ext4_calculate_overhead() bug.
Date: Wed, 28 Nov 2012 12:45:15 -0500
Message-ID: <20121128174515.GC24431@thunk.org>
References: <1353544101-5154-1-git-send-email-vmartirosyan@linuxtesting.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vahram Martirosyan <vmartirosyan@linuxtesting.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vahram Martirosyan <vmartirosyan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1353544101-5154-1-git-send-email-vmartirosyan@linuxtesting.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 21, 2012 at 04:28:21PM -0800, Vahram Martirosyan wrote:
> The memset operation before check brings to a BUG.
> No need to memset the page with zeroes.
> 
> The patch removes the memset call in ext4_calculate_overhead() function.
> 
> Found by the Spruce system in cooperation with the KEDR Framework.
> 
> Signed-off-by: Vahram Martirosyan <vmartirosyan@linuxtesting.org>

Applied, with a slightly rewritten commit description:

    ext4: fixed potential NULL dereference in ext4_calculate_overhead()
    
    The memset operation before check can cause a BUG if the memory
    allocation failed.  Since we are using get_zeroed_age, there is no
    need to use memset anyway.
    
    Found by the Spruce system in cooperation with the KEDR Framework.
    
    Signed-off-by: Vahram Martirosyan <vmartirosyan@linuxtesting.org>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
