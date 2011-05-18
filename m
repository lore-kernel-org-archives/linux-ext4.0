From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] xfstests:Make 225 compare map and fiemap at each block.
Date: Wed, 18 May 2011 09:05:19 -0400
Message-ID: <4DD3C40F.1040808@redhat.com>
References: <BANLkTi=ra8eKxqstqFqDWHYsQpVx66c8BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@sandeen.net>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	xfs@oss.sgi.com
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1ERNFZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 09:05:25 -0400
In-Reply-To: <BANLkTi=ra8eKxqstqFqDWHYsQpVx66c8BQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/13/2011 11:47 PM, Yongqiang Yang wrote:
> Hi All,
>
> Due to my carelessness, I induced a ugly patch to ext4's fiemap, but
> 225 could not find it.  So I looked into the 225 and could not figure out
> logic in compare_map_and_fiemap(), which seemed to mixed extents with
> blocks.  Then I made 225 compare map and fiemap at each block, the new
> 225 can find another bug in ext4's fiemap.
>
> The new 225 works well on ext3 and ext4 with both 1K and 4K block. However,
> it report fiemap error on xfs with 4K block.  My working tree is 2.6.39-rc3
> pulled from Ted's tree. The error message is as follows.
>
>   QA output created by 225
>   fiemap run without preallocation, with sync
> +map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDH
> DDDDDDDDHDDHHHDDDHDDHHDDDDDDHHHHHHDDHHHHHDHDHDHDD
> DHDDHD'
> +logical: [       0..      15] phys:       12..      27 flags: 0x000 tot: 16
> +logical: [      17..      31] phys:       29..      43 flags: 0x000 tot: 15
> +logical: [      34..      63] phys:       46..      75 flags: 0x000 tot: 30
> +logical: [      65..      95] phys:       77..     107 flags: 0x001 tot: 31
> +Problem comparing fiemap and map
>   fiemap run without preallocation or sync
> +map is 'DDHDHHDHHDHDDHDDHDDHHDHDDHDDDDDDHHDDDHHHHDH
> DDDDDDDDHDDHHHDDDHDDHHDDDDDDHHHHHHDDHHHHHDHDHDHDD
> DHDDHD'
> +logical: [       0..      15] phys:        0..      15 flags: 0x006 tot: 16
> +Problem comparing fiemap and map
> Ran: 225
> Failures: 225
> Failed 1 of 1 tests
>
> I am not sure this is a bug in new 225 or xfs.
>
> Yongqiang.
>
> Signed-off-by: Yongqiang Yang<xiaoqiangnk@gmail.com>
> ---
>   src/fiemap-tester.c |  223 ++++++++++++++++++++++++++++----------------------
>   1 files changed, 125 insertions(+), 98 deletions(-)
>
> diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
> index 1663f84..99bb5ce 100644
> --- a/src/fiemap-tester.c
> +++ b/src/fiemap-tester.c
> @@ -14,6 +14,9 @@
>    * You should have received a copy of the GNU General Public License
>    * along with this program; if not, write the Free Software Foundation,
>    * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + *
> + * Compare map and fiemap at each block,
> + * Yongqiang Yang<xiaoqiangnk@gmail.com>, 2011
>    */
>
>   #include<stdio.h>
> @@ -57,7 +60,7 @@ generate_file_mapping(int blocks, int prealloc)
>   	int num_types = 2, cur_block = 0;
>   	int i = 0;
>
> -	map = malloc(sizeof(char) * blocks);
> +	map = malloc(sizeof(char) * (blocks + 1));
>   	if (!map)
>   		return NULL;
>
> @@ -80,7 +83,8 @@ generate_file_mapping(int blocks, int prealloc)
>   		}
>   		cur_block++;
>   	}
> -
> +	
> +	map[blocks] = 0;
>   	return map;
>   }
>
> @@ -247,55 +251,36 @@ check_flags(struct fiemap *fiemap, int blocksize)
>   }
>
>   static int
> -check_data(struct fiemap *fiemap, __u64 logical_offset, int blocksize,
> +check_data(struct fiemap_extent * extent ,  __u64 logical_offset, int
> blocksize,
>   	   int last, int prealloc)
>   {

This chunk is messed up, it's failing to apply.  Overall it looks good, 
but could you clean this up and resend so I can apply it and test it 
more thoroughly?  Thanks,

Josef
