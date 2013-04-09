From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Fwd: block level cow operation
Date: Tue, 09 Apr 2013 18:46:50 +0400
Message-ID: <87txnfrcbp.fsf@openvz.org>
References: <CAD6i1f+GsVZJwaz1R3NDjP_m8nOCUsmqHTQS3R=M+d+hq8f5vw@mail.gmail.com> <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Prashant Shah <pshah.mumbai@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:40626 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761532Ab3DIOqy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Apr 2013 10:46:54 -0400
Received: by mail-la0-f53.google.com with SMTP id fp12so3685051lab.12
        for <linux-ext4@vger.kernel.org>; Tue, 09 Apr 2013 07:46:53 -0700 (PDT)
In-Reply-To: <CAD6i1f+NLF6Vj8D84FFWAbDttqbBvcg-kWswf7Hez2o0-cXpMw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Apr 2013 14:35:56 +0530, Prashant Shah <pshah.mumbai@gmail.com> wrote:
> Hi,
> 
> I am trying to implement copy on write operation by reading the
> original disk block and writing it to some other location and then
> allowing the write to pass though (block the write operation till the
> read or original block completes) I tried using submit_bio() /
> sb_bread() to read the block and using the completion API to signal
> the end of reading the block but the performance of this is very bad.
> It takes around 12 times more time for any disk writes. Is there any
> better way to improve the performance ?
> 
Yes obviously instead of synchronous  block handling (block by block)
which give about  ~1-3Mb/s 

you should not block bio/requests handling, but simply deffer original
bio. Some things like that:

OUR_MAIN_ENTERING_POINT {
  if (bio->bi_rw == WRITE) {
     if (cow_required(bio))
       cow_bio  = create_cow_copy(bio)
       submit_bio(cow_bio);
   }
  /* Cow is not required */ 
   submit_bio(bio);
}
create_cow_bio(struct *bio)
{
        /* Save original content, and once it will be done we will 
         * issue original bio */
         */
        cow_bio = alloc_bio();
        cow_bio.bi_sector = bio->bi_sector;
        ....
        cow_bio->bi_private = bio;
        cow_bio->bi_end_io = cow_end_io
}
cow_end_io(struct bio *cow_bio, int error) ;
{
       /* Once we done with saving original content we may send original
          bio, But end_io may be called from various contexts even from
          interrupt context , so we are not allowed to call submit_bio()
          So we will put original bio to the list and let our worker
          thread submit it for us later
        */
       add_bio_to_the_list((struct bio*)cow_bio->bi_private);
}

This approach gives us reasonable performance ~3 times slower than disk
throughput.
For a reference implementation you may look at driver/dm/dm-snap or to
Acronis snapapi module (AFAIR it is opensource)
}
> Not waiting for the completion of the read operation and letting the
> disk write go through gives good performance but under 10% of the
> cases the read happens after the write and ends up the the new data
> and not the original data.
Noooo never do that. Block layer will not guarantee you an order.
> 
> Regards.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
