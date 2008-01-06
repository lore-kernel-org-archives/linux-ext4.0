From: Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: [PATCH 1/3] byteorder: move le32_add_cpu &
	friends from OCFS2 to core
Date: Sun, 6 Jan 2008 12:50:55 -0800
Message-ID: <20080106205055.GR23506@ca-server1.us.oracle.com>
References: <1199547382-29969-1-git-send-email-marcin.slusarz@gmail.com>
	<1199547382-29969-2-git-send-email-marcin.slusarz@gmail.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernel-janitors <kernel-janitors@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com,
        Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
        OCFS2-devel <ocfs2-devel@oss.oracle.com>
To: marcin.slusarz@gmail.com
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
Content-Disposition: inline
In-Reply-To: <1199547382-29969-2-git-send-email-marcin.slusarz@gmail.com>
List-Unsubscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <http://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
List-Id: linux-ext4.vger.kernel.org

On Sat, Jan 05, 2008 at 04:36:20PM +0100, marcin.slusarz@gmail.com wrote:
> - move inline functions which add native byte order variable to
>   little/big endian variable to core header
>   * le16_add_cpu(__le16 *var, u16 val)
>   * le32_add_cpu(__le32 *var, u32 val)
>   * le64_add_cpu(__le64 *var, u64 val)
>   * be32_add_cpu(__be32 *var, u32 val)
> - add for completeness:
>   * be16_add_cpu(__be16 *var, u16 val)
>   * be64_add_cpu(__be64 *var, u64 val)
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Acked-by: Mark Fasheh <mark.fasheh@oracle.com>

--
Mark Fasheh
Principal Software Developer, Oracle
mark.fasheh@oracle.com
