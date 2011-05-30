From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: use little-endian bitops directly
Date: Mon, 30 May 2011 11:43:57 -0400
Message-ID: <20110530154357.GF2890@dhcp-172-31-194-241.cam.corp.google.com>
References: <1306763382-13817-1-git-send-email-akinobu.mita@gmail.com>
 <09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <09010AAD-7443-4966-BF20-8580FBE8F389@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 30, 2011 at 08:49:43AM -0600, Andreas Dilger wrote:
> On 2011-05-30, at 7:49 AM, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> > s/ext4_set_bit/__test_and_set_bit_le/
> > s/ext4_clear_bit/__test_and_clear_bit_le/
> > s/ext4_test_bit/test_bit_le/
> > s/ext4_find_first_zero_bit/find_first_zero_bit_le/
> > s/ext4_find_next_zero_bit/find_next_zero_bit_le/
> > s/ext4_find_next_bit/find_next_bit_le/
> 
> I'm not souch in favor of making this change. One reason is the need
> for inconsistent test_bit_le() vs __test_and_set_bit_le()
> functions. I think this will make it more difficult to get the
> correct bit operations (I for one do not know the difference between
> the normal and __ versions without looking each time).

More to the point, what's the benefit of making this change?

     	    	   	      	      	 - Ted
