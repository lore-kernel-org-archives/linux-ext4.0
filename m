From: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Fri, 12 Jul 2013 09:15:06 -0400
Message-ID: <CA+5PVA4C0PsQ20r_sg=me6QwGFJJTwbGdQZz6N9481H_=WkZsw@mail.gmail.com>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
	<51DC1AC5.8010809@redhat.com>
	<20130709143855.GF6000@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130709143855.GF6000@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 9, 2013 at 10:38 AM, Theodore Ts'o <tytso@mit.edu> wrote:
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

Greg, are these 4 commits part of the large pile you're sitting on
right now?  Just want to make sure the request wasn't missed, as they
lack the CC to stable.

josh
