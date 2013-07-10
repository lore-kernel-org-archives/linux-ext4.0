From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Wed, 10 Jul 2013 16:40:12 +0100
Message-ID: <874nc21l0j.fsf@canonical.com>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
	<51DC1AC5.8010809@redhat.com> <20130709143855.GF6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130709143855.GF6000@thunk.org> (Theodore Ts'o's message of
	"Tue, 9 Jul 2013 10:38:55 -0400")
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

"Theodore Ts'o" <tytso@mit.edu> writes:

> On Tue, Jul 09, 2013 at 09:14:29AM -0500, Eric Sandeen wrote:
>> 
>> I don't think these did get cc'd to stable.  Was there a reason for that,
>> or was it an oversight?
>
> It was an oversight; my fault, sorry.  I'll send a request to the
> stable kernel tree for the following patches:
>
> 8af8eec ext4: fix overflow when counting used blocks on 32-bit architectures
> a60697f ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
> e7293fd ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
> eaf3793 ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
>
> 	      	       	      	       	  	 - Ted

Thanks Ted.  All of these patches seem to be applicable to the 3.8
kernel.  As for the 3.5 kernel, I'm queuing the first 2 patches only.

Cheers,
-- 
Luis
