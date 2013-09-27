From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] e2image: Print a warning if running over a mounted
 filesystem
Date: Fri, 27 Sep 2013 15:10:48 -0300
Message-ID: <20130927181047.GA30019@orion.maiolino.org>
References: <1380296025-28937-1-git-send-email-cmaiolino@redhat.com>
 <5245B463.90209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab3I0SKx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Sep 2013 14:10:53 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8RIAqIm030925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Sep 2013 14:10:53 -0400
Received: from orion.maiolino.org (ovpn-113-161.phx2.redhat.com [10.3.113.161])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r8RIAmjj024261
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 27 Sep 2013 14:10:51 -0400
Content-Disposition: inline
In-Reply-To: <5245B463.90209@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Eric,

> manpage updates, please :)
> 

I'm writing a manpage patch to talk about it, I'm just waiting until everybody
accepts this patch and I can write a manpage patch to the proper fix (instead of
need to re-write both, patch and manpage).

About the comment, yes, I agree, doing that and sending a V3

Thanks for the review

> My only other nitpick would be that a comment somewhere before:
> 
> +		if (img_type && !ignore_rw_mount) {
> +			fprintf(stderr, "Use -f option if you really want to "
> +					"do that.\n");
> 
> to explain why that condition requires -f, but the other (!img_type)
> does not, would be helpful to future code-readers.
> 
> Thanks,
> -Eric
> 
> > ---
> >  misc/e2image.c | 24 ++++++++++++++++++++++--
> >  1 file changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/misc/e2image.c b/misc/e2image.c
> > index 885a794..248399d 100644
> > --- a/misc/e2image.c
> > +++ b/misc/e2image.c
> > @@ -87,7 +87,7 @@ static int get_bits_from_size(size_t size)
> >  
> >  static void usage(void)
> >  {
> > -	fprintf(stderr, _("Usage: %s [-rsIQa] device image_file\n"),
> > +	fprintf(stderr, _("Usage: %s [-rsIQaf] device image_file\n"),
> >  		program_name);
> >  	exit (1);
> >  }
> > @@ -1252,9 +1252,11 @@ int main (int argc, char ** argv)
> >  	int open_flag = EXT2_FLAG_64BITS;
> >  	int img_type = 0;
> >  	int flags = 0;
> > +	int mount_flags = 0;
> >  	int qcow2_fd = 0;
> >  	int fd = 0;
> >  	int ret = 0;
> > +	int ignore_rw_mount = 0;
> >  	struct stat st;
> >  
> >  #ifdef ENABLE_NLS
> > @@ -1269,7 +1271,7 @@ int main (int argc, char ** argv)
> >  	if (argc && *argv)
> >  		program_name = *argv;
> >  	add_error_table(&et_ext2_error_table);
> > -	while ((c = getopt(argc, argv, "rsIQa")) != EOF)
> > +	while ((c = getopt(argc, argv, "rsIQaf")) != EOF)
> >  		switch (c) {
> >  		case 'I':
> >  			flags |= E2IMAGE_INSTALL_FLAG;
> > @@ -1290,6 +1292,9 @@ int main (int argc, char ** argv)
> >  		case 'a':
> >  			all_data = 1;
> >  			break;
> > +		case 'f':
> > +			ignore_rw_mount = 1;
> > +			break;
> >  		default:
> >  			usage();
> >  		}
> > @@ -1305,6 +1310,21 @@ int main (int argc, char ** argv)
> >  	device_name = argv[optind];
> >  	image_fn = argv[optind+1];
> >  
> > +	ext2fs_check_if_mounted(device_name, &mount_flags);
> > +
> > +	if ((mount_flags & EXT2_MF_MOUNTED) &&
> > +	   !(mount_flags & EXT2_MF_READONLY)) {
> > +		fprintf(stderr, "\nWarning: Running e2image on a mounted "
> > +				"RW filesystem can result in an inconsistent "
> > +				"image which will not be useful for "
> > +				"debugging purposes.\n");
> > +		if (img_type && !ignore_rw_mount) {
> > +			fprintf(stderr, "Use -f option if you really want to "
> > +					"do that.\n");
> > +			exit(1);
> > +		}
> > +	}
> > +
> >  	if (flags & E2IMAGE_INSTALL_FLAG) {
> >  		install_image(device_name, image_fn, img_type);
> >  		exit (0);
> > 
> 

-- 
Carlos
