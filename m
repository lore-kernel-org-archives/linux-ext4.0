From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Thu, 05 May 2011 12:29:04 +0100
Message-ID: <4DC28A00.7010309@draigBrady.com>
References: <20110414102608.GA1678@x4.trippels.de>	<20110414120635.GB1678@x4.trippels.de>	<20110414140222.GB1679@x4.trippels.de>	<4DA70BD3.1070409@draigBrady.com>	<4DA717B2.3020305@sandeen.net>	<4DA7182B.8050409@draigBrady.com>	<4DA71920.9@sandeen.net>	<BANLkTikW72q_2pEoVTmag8+gMsCcZ-fR8w@mail.gmail.com>
	<BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>,
	coreutils-mXXj517/zsQ@public.gmane.org, Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>,
	xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>
To: Yongqiang Yang <xiaoqiangnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
In-Reply-To: <BANLkTimoLeWMJgNFGW+zdeUeJyZ-_+8fMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <https://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 14/04/11 17:10, Yongqiang Yang wrote:
> Hi,
> 
> I am off my working computer.  Maybe below fix could fix the problem.
> 
> fs/ext4/extent.c
> static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
> 1877                 } else if (block >= le32_to_cpu(ex->ee_block)) {
> 1878                         /*
> 1879                          * some part of requested space is covered
> 1880                          * by found extent
> 1881                          */
> 1882                         start = block;
> 1883                         end = le32_to_cpu(ex->ee_block)
> 1884                                 + ext4_ext_get_actual_len(ex);
> 1885                         if (block + num < end)
> 1886                                 end = block + num;
>        +                        if (!ext4_ext_is_uninitialized(ex))
> 1887                         exists = 1;
> 1888                 } else {
> 1889                         BUG();
> 1890                 }

Hi,

To follow up on the above.  I'm under the impression
that ext4 is expected to return extents for what
is written, irrespective of whether it's reached the
disk or not. I.E. the preallocation case where this fails
was an oversite, for which the above might fix.

So is the above summary correct, and has there
been any more thoughts on a fix?

cheers,
Pádraig.
