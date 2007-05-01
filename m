From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: Ext4 devel interlock meeting minutes (April 23, 2007)
Date: Tue, 01 May 2007 17:38:53 +0530
Message-ID: <1178021333.7428.8.camel@garfield>
References: <462D42CA.50509@linux.vnet.ibm.com>
	 <cc723f590704300406l5c3a8a84y2cd3aecd52209c2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-N+yqhCQL1RhFIaAaG126"
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Aneesh Kumar <aneesh.kumar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:54628 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031682AbXEAMGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 May 2007 08:06:05 -0400
In-Reply-To: <cc723f590704300406l5c3a8a84y2cd3aecd52209c2b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-N+yqhCQL1RhFIaAaG126
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2007-04-30 at 16:36 +0530, Aneesh Kumar wrote:
> On 4/24/07, Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:
> > Ext4 Developer Interlock Call: 04/23/2007 Meeting Minutes
> >
> > TESTING
> > - extents testing
> >     - Discussed methods for testing extents on highly fragmented
> > filesystems.
> >     - Jose will look into possible tests, including perhaps using the
> > 'aged' option in FFSB
> >     - Ted suggested creating a mountoption that creates a bad block
> > allocator which it jumps to a new block group every 8 blocks.  This
> > would force a very large number of extents, and may be a good test for
> > extents.
> 
> 
> What i am doing for creating a large number of extents is
> 
> dd if=/dev/zero of=myfile count=10
> seek=20
> while [ 1 ]; do dd if=/dev/zero of=myfile count=10 seek=$seek;
> seek=`expr $seek + 20`; done
> 
> 

I had written a simple tool "bitmap_manip" with which you can actually
manipulate the number of free chunks and their sizes in a filesystem. It
uses libext2fs to set the bits in block bitmaps thereby leaving the
desired free extents. I had written it to test the allocators
performance. 

It can be used as:
 ./bitmap_manip /dev/sda9 1MA 4 16K 1 12K 3 8K 4 4K 6
 
This will leave only 1 16K chunk, 3 12K chunks, .... free in the
filesystem. "1MA" 4 will get us 4 1Mb free ALIGNED chunks.

It isn't very beautiful code since it was only used for testing but
maybe it can help.

Thanks,
Kalpak.

> -aneesh
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-N+yqhCQL1RhFIaAaG126
Content-Disposition: attachment; filename=bitmap_manip.c
Content-Type: text/x-csrc; name=bitmap_manip.c; charset=utf-8
Content-Transfer-Encoding: 7bit

/* Manipulate block bitmap directly for mballoc testing */

/* USAGE:
 * ./bitmap_manip /dev/volmballoc/test 16K 1 12K 3 8K 4 4K 6
 * This will leave 1 16K chunk, 3 12K chunks, .... in the filesystem specified.
 * Ideally give the inputs in ascending order. 
 * 1MA 4 will get us 4 1Mb ALIGNED chunks.	
 */

#include <stdio.h>
#include <ext2fs/ext2fs.h>
#include <ext2fs/ext2_types.h>
#include <fcntl.h>
#include <stdlib.h>

#define ONE_MB (1024 * 1024)
#define ONE_KB 1024

#define SETTING 0
#define FREEING 1

#define NO_ALIGN 0
#define ALIGN 1

struct chunk_arg {
	int chunk_size;
	int num_chunks;
	int align;
};

int main(int argc, char **argv)
{
	ext2_filsys fs;
	ext2fs_block_bitmap *map = NULL;
	int bg_num = 0, retval, arg_num, multiply, chunk_num;
	int i, start_blk, set_bit, test_bit, j;
	struct chunk_arg chunk[50];
	int free_blocks_req = 0, free_blocks_avail, num_of_chunks_req = 0, group;
	char str[10];
	float orig_avail_req, avail_req;
	int set_till_now, free_till_now, num_blks_to_set, num_blks_to_free, phase;
	int  current, align_flag = 0, align = 0, curr = 0;

	if (argc < 2) {
		printf("Please give name of a filesystem. Exiting...\n");
		return -1;
	}
	
	/* Even from user's perspective */
	if(argc & 0x01) {
		printf("This utility cannot have even number of arguments.\n");
		return -1;
	}

	if ((retval = ext2fs_open(argv[1], EXT2_FLAG_RW, 0, 0, unix_io_manager, &fs))) {
		com_err("ext2fs open:", retval, "while opening %s\n", argv[1]);
		return retval;
	}	

	srand(1234567);
	chunk_num = 0;
	for (arg_num = 2; arg_num < argc; arg_num += 2, chunk_num++) {
		strcpy(str, argv[arg_num]);

		/* Check if we have to align */
		if (toupper(str[strlen(str) - 1 ]) == 'A') {
			chunk[chunk_num].align = ALIGN;
			str[strlen(str) - 1] = '\0';	
			align = 1;
		}
		else
			chunk[chunk_num].align = NO_ALIGN;
		if (toupper(str[strlen(str) - 1]) == 'K')
			multiply = ONE_KB;
		else if(toupper(str[strlen(str) - 1]) == 'M') 
			multiply = ONE_MB;

		str[strlen(str) - 1] = '\0';
		chunk[chunk_num].chunk_size = ((strtod(str, NULL)) * multiply)/ (fs->blocksize);
		chunk[chunk_num].num_chunks = strtod(argv[arg_num + 1], NULL); 
			
		free_blocks_req += chunk[chunk_num].chunk_size * chunk[chunk_num].num_chunks;
		num_of_chunks_req += chunk[chunk_num].num_chunks;
	}

	ext2fs_read_block_bitmap(fs);			
	map = &fs->block_map;	

	start_blk = fs->super->s_first_data_block;
	free_blocks_avail = fs->super->s_free_blocks_count;

	orig_avail_req = free_blocks_avail / free_blocks_req;
	current = 0;
	i = start_blk;
	
	num_blks_to_set = (orig_avail_req / 4) * chunk[current].chunk_size;
	num_blks_to_free = chunk[current].chunk_size;
	phase = SETTING;
	do {
		test_bit = i;
		if (!ext2fs_fast_test_block_bitmap(*map, test_bit)) {
			if (phase == SETTING) {				
				if (chunk[current].align == ALIGN && chunk[current].num_chunks > 0) {
					if (align_flag == 0) {
						num_blks_to_set = (i / chunk[current].chunk_size + 1) * 
							chunk[current].chunk_size - i;
						align_flag = 1;
					}
					else if (i % chunk[current].chunk_size == 0) {
						num_blks_to_set = 0;
						phase = FREEING;
					}
				}
				set_bit = i;
		                ext2fs_mark_block_bitmap(*map, set_bit); 
				group = (set_bit - fs->super->s_first_data_block) / fs->super->s_blocks_per_group;
				fs->group_desc[group].bg_free_blocks_count--;
				fs->super->s_free_blocks_count--;		
				num_blks_to_set--;
				if (num_blks_to_set == 0) {
					phase = FREEING;
					align_flag = 0;
				}
			}
			else if (phase == FREEING) { 
				free_blocks_req--;
				num_blks_to_free--;
				if (num_blks_to_free == 0) {
					/* Decide how many blocks to set */
					phase = SETTING;
					num_of_chunks_req--;
					chunk[current].num_chunks--;
					
					/* No more free chunks required*/
					if (num_of_chunks_req == 0) {
						num_blks_to_set = free_blocks_avail;
					}
					else {
						for (j = 0; j < chunk_num; j++) {	
							if (chunk[j].num_chunks > 0) {	
								if (free_blocks_req > chunk[j].num_chunks * 
 									    chunk[j].chunk_size && current == j) {
									continue;
								}
								else {
									current = j;
									break;	
								}
							}
						}							
  					        avail_req = free_blocks_avail / free_blocks_req;
						if (align != 1)
	       						num_blks_to_set = (avail_req / 4) * 
								    chunk[current].chunk_size;
						else 
							num_blks_to_set = 20;
						num_blks_to_free = chunk[current].chunk_size;		
						/* Make sure a free block does not break across block groups */
						curr = i % 32767;
						curr = 32767 * (curr + 1);
						if (i + num_blks_to_set + num_blks_to_free > curr && i < curr)	
							num_blks_to_set += (curr) - (i + num_blks_to_set);
					}
				}
			}												
			free_blocks_avail--;	
		}
                i++;
	}while(i <= (fs->super->s_blocks_count - 1) || free_blocks_avail != 0);

        ext2fs_mark_bb_dirty(fs);
        ext2fs_mark_super_dirty(fs);

	if (i == fs->super->s_blocks_count && free_blocks_req != 0) {
		printf("Block manipulation failed. Sorry.\n");
		return 0;
	}		

	ext2fs_close(fs);	
	return 0;
}

--=-N+yqhCQL1RhFIaAaG126--
