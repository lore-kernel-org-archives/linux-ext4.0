From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Mon, 24 Jun 2013 18:35:37 +0900
Message-ID: <CAKYAXd-hJ71+zDn5c2ABb2J-zL=kb2M=GNzOWNHkS7-C4KXEzA@mail.gmail.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
	<03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
	<7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
	<20130624024459.GJ29376@dastard>
	<20130624070656.GA20166@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130624070656.GA20166@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2013/6/24, Christoph Hellwig <hch@infradead.org>:
> On Mon, Jun 24, 2013 at 12:44:59PM +1000, Dave Chinner wrote:
>> various DVR companies shipping equivalent ioctl-based functionality
>> for XFS filesystems to both insert and remove chunks in video
>> streams, but I've never been able to find the code for it anywhere.
>
Hi. Christoph.
> Samsung does this, also for UDF.  Namjae, could you please submit these
> two as well, including a proper VFS interface?
Yes, Sure.
Intially, we also thought of adding a new flag to fallocate instead of ioctls.
But as Ted rightly pointed, fallocate works on byte granularity and we
have block aligned restrictions, so once we decided to go for ioctls
and hear other people opninons.
Currently, we can try implementing dave's suggesstion of introducing a
new flag FALLOC_FL_COLLAPSE_RANGE  for falloctae instead of individual
ioctls for both XFS and EXT4.

Thanks.
>
>
