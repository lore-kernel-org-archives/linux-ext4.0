From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Fri, 12 Jul 2013 07:50:16 -0700
Message-ID: <20130712145016.GB9979@kroah.com>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
 <51DC1AC5.8010809@redhat.com>
 <20130709143855.GF6000@thunk.org>
 <CA+5PVA4C0PsQ20r_sg=me6QwGFJJTwbGdQZz6N9481H_=WkZsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
To: Josh Boyer <jwboyer@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA4C0PsQ20r_sg=me6QwGFJJTwbGdQZz6N9481H_=WkZsw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 12, 2013 at 09:15:06AM -0400, Josh Boyer wrote:
> On Tue, Jul 9, 2013 at 10:38 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Tue, Jul 09, 2013 at 09:14:29AM -0500, Eric Sandeen wrote:
> >>
> >> I don't think these did get cc'd to stable.  Was there a reason for that,
> >> or was it an oversight?
> >
> > It was an oversight; my fault, sorry.  I'll send a request to the
> > stable kernel tree for the following patches:
> >
> > 8af8eec ext4: fix overflow when counting used blocks on 32-bit architectures
> > a60697f ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
> > e7293fd ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
> > eaf3793 ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
> 
> Greg, are these 4 commits part of the large pile you're sitting on
> right now?  Just want to make sure the request wasn't missed, as they
> lack the CC to stable.

They are still in my "to-apply" queue, and are not lost.  And I wasn't
counting them in the 170 patches I have to review, make that 174 now :)

thanks,

greg k-h
