From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Tue, 1 Apr 2014 09:19:12 +0900
Message-ID: <CAKYAXd8adbqepWeDADDtbzk7bTrhXK0CccgewNDsqu0u+HnC4g@mail.gmail.com>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
	<20140331145625.GA10791@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	=?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140331145625.GA10791@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2014-03-31 23:56 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
> On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
>> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
>> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
>> in between the file within the range specified by offset and len. User can
>> write new data in this space. e.g. ads.
>> Like collapse range, currently we have the limitation that offset and len
>> should be block size aligned for both XFS and Ext4.
>
> Btw, I remember Samsung also had an ioctl for XFS to split a file into
> two without moving the data, do you plan to submit that one as well?
>
Hi Christoph.
Sure, I'm planning to introduce FS_IOC_MOVE_DATA ioctl that can split
file as well as merging for xfs and ext4.
I already started to implement it. and will post it soon.

Thanks.
