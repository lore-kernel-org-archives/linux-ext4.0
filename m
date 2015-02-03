From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ext4: fix warning in ext4_da_update_reserve_space()
Date: Tue, 3 Feb 2015 14:53:43 -0800
Message-ID: <20150203225343.GA3539@kroah.com>
References: <1420750108-11512-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu,
	jack@suse.cz
To: Josh Hunt <johunt@akamai.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420750108-11512-1-git-send-email-johunt@akamai.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 08, 2015 at 03:48:28PM -0500, Josh Hunt wrote:
>     Please add the patch below and referenced dependency (0e95c22) to stable
>     3.10.y.

There is no such commit "0e95c22" in Linus's tree, do you mean
"1c8924eb106c1ac755d5d35ce9b3ff42e89e2511"?  If so, that doesn't apply
to 3.10 at all, so I can't apply that on, and so, can't apply the patch
below either :(

Care to provide proper backports of both of them?

thanks,

greg k-h
