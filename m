From: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Mon, 24 Jun 2013 10:37:57 +0000
Message-ID: <C0F0BC787567C848B2C90989451123DA2363CDB7@ATLEXMBX4.ARRS.ARRISI.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
 <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
 <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
 <20130624024459.GJ29376@dastard> <20130624070656.GA20166@infradead.org>
 <CAKYAXd-hJ71+zDn5c2ABb2J-zL=kb2M=GNzOWNHkS7-C4KXEzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 24.06.2013 13:36, Namjae Jeon wrote:
> Currently, we can try implementing dave's suggesstion of introducing a
> new flag FALLOC_FL_COLLAPSE_RANGE for falloctae instead of individual
> ioctls for both XFS and EXT4. Thanks.

Hi,

Currently PUNCH_HOLE requires KEEP_SIZE to be set as well. I think there
is no need to invent COLLAPSE_RANGE, but instead fallocate should
support PUNCH_HOLE without KEEP_SIZE. However I'm not sure that putting
block alignment restriction is a right way to go.

Regards,
Andrey.
