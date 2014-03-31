From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] fs: Introduce FALLOC_FL_INSERT_RANGE for fallocate
Date: Mon, 31 Mar 2014 07:56:25 -0700
Message-ID: <20140331145625.GA10791@infradead.org>
References: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	linux-ext4@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <1396277611-10759-1-git-send-email-linkinjeon@gmail.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 31, 2014 at 11:53:31PM +0900, Namjae Jeon wrote:
> This flag will work opposite to the newly added FALLOC_FL_COLLAPSE_RANGE flag.
> As such, specifying FALLOC_FL_INSERT_RANGE flag will insert zeroed-out space
> in between the file within the range specified by offset and len. User can
> write new data in this space. e.g. ads.
> Like collapse range, currently we have the limitation that offset and len
> should be block size aligned for both XFS and Ext4.

Btw, I remember Samsung also had an ioctl for XFS to split a file into
two without moving the data, do you plan to submit that one as well?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
