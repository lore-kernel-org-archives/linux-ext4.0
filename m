From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Thu, 4 Aug 2016 14:59:01 -0500
Message-ID: <57A39E85.6000606@redhat.com>
References: <201608050158.hllBWy4G%fengguang.wu@intel.com>
 <38523086-1436-fdbf-bd89-9f31ad134bed@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, ross.zwisler@linux.intel.com,
	linux-ext4@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	minchan@kernel.org, ngupta@vflare.org, vishal.l.verma@intel.com
To: Jens Axboe <axboe@kernel.dk>, kbuild test robot <lkp@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <38523086-1436-fdbf-bd89-9f31ad134bed@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 08/04/2016 02:27 PM, Jens Axboe wrote:
> On 08/04/2016 11:50 AM, kbuild test robot wrote:
>> Hi Mike,
>>
>> [auto build test ERROR on linus/master]
>> [also build test ERROR on next-20160804]
>> [cannot apply to v4.7]
>> [if your patch is applied to the wrong git tree, please drop us a note
>> to help improve the system]
>>
>> url:   
>> https://github.com/0day-ci/linux/commits/Mike-Christie/mm-block-convert-rw_page-users-to-bio-op-use/20160805-012041
>>
>> config: i386-tinyconfig (attached as .config)
>> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
>> reproduce:
>>         # save the attached .config to linux build tree
>>         make ARCH=i386
>>
>> All errors (new ones prefixed by >>):
>>
>>    mm/filemap.c: In function 'page_endio':
>>>> mm/filemap.c:892:7: error: implicit declaration of function
>>>> 'op_is_write' [-Werror=implicit-function-declaration]
>>      if (!op_is_write(op)) {
>>           ^~~~~~~~~~~
> 
> Mike, how about moving op_is_write() outside of CONFIG_BLOCK protection
> in fs.h, and making the REQ_OP_* enum generally available as well? That
> should fix it.
> 
> 
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index f254eb264924..14b28ff2caf8 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -18,6 +18,17 @@ struct cgroup_subsys_state;
>  typedef void (bio_end_io_t) (struct bio *);
>  typedef void (bio_destructor_t) (struct bio *);
> 
> +enum req_op {
> +    REQ_OP_READ,
> +    REQ_OP_WRITE,
> +    REQ_OP_DISCARD,        /* request to discard sectors */
> +    REQ_OP_SECURE_ERASE,    /* request to securely erase sectors */
> +    REQ_OP_WRITE_SAME,    /* write same block many times */
> +    REQ_OP_FLUSH,        /* request for cache flush */
> +};
> +
> +#define REQ_OP_BITS 3
> +
>  #ifdef CONFIG_BLOCK
>  /*
>   * main unit of I/O for the block layer and lower layers (ie drivers and
> @@ -228,17 +239,6 @@ enum rq_flag_bits {
>  #define REQ_HASHED        (1ULL << __REQ_HASHED)
>  #define REQ_MQ_INFLIGHT        (1ULL << __REQ_MQ_INFLIGHT)
> 
> -enum req_op {
> -    REQ_OP_READ,
> -    REQ_OP_WRITE,
> -    REQ_OP_DISCARD,        /* request to discard sectors */
> -    REQ_OP_SECURE_ERASE,    /* request to securely erase sectors */
> -    REQ_OP_WRITE_SAME,    /* write same block many times */
> -    REQ_OP_FLUSH,        /* request for cache flush */
> -};
> -
> -#define REQ_OP_BITS 3
> -
>  typedef unsigned int blk_qc_t;
>  #define BLK_QC_T_NONE    -1U
>  #define BLK_QC_T_SHIFT    16
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f2a69f20926f..13cc1bfce9aa 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2465,12 +2465,13 @@ extern void init_special_inode(struct inode *,
> umode_t, dev_t);
>  extern void make_bad_inode(struct inode *);
>  extern bool is_bad_inode(struct inode *);
> 
> -#ifdef CONFIG_BLOCK
>  static inline bool op_is_write(unsigned int op)
>  {
>      return op == REQ_OP_READ ? false : true;
>  }
> 
> +#ifdef CONFIG_BLOCK
> +
>  /*
>   * return data direction, READ or WRITE
>   */
> 


Looks ok to me. Did a quick build and test run with it.


